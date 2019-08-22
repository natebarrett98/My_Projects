#To Create a Fresh Daily Count Table of the last 1000 entries For Any of the Following:
#google_trends_data,reddit_posts,reddit_users,subreddits,tweets,twitter_users
#Requires the MYSQL Python Connector (availible in MySQL Installer)


import mysql.connector
import pandas as pd


#Will only create a new daily count table if one isn't already made.
#Will throw error if one is already made dor the certain table
def create_daily_count_tbl(tbl_name):
    
    
    
    mydb = mysql.connector.connect(
    host="ornus.cwrnsgadkrxd.us-west-1.rds.amazonaws.com",
    user="ornus",
    passwd="ornus_capital88",
    database="ornus"
  
    )

    mycursor = mydb.cursor()

    if tbl_name in ("reddit_users","twitter_users","subreddits"):
         mycursor.execute("SELECT * FROM "+tbl_name+" ORDER BY date_created desc LIMIT 1000")
    else:
         mycursor.execute("SELECT * FROM "+tbl_name+" ORDER BY date desc LIMIT 1000")
        


    

    myresult1 = mycursor.fetchall()

    rstls1 = pd.DataFrame(myresult1)

    if tbl_name in ("reddit_users","twitter_users") :
        gh = rstls1.groupby(rstls1[2]).count()
    elif tbl_name in ("google_trends_data"):
        gh = rstls1.groupby(rstls1[0]).count()
    else:
        gh = rstls1.groupby(rstls1[1]).count()
    
    
    if tbl_name in ("google_trends_data"):
        data = {"date" : list(gh.index.values),
        "count": gh[1].astype('int32').values}
    else:
        data = {"date" : list(gh.index.values),
        "count": gh[0].astype('int32').values}
        
    

    time = pd.DataFrame(data)
    
    subset = time[['date', 'count']]
    tuples = [tuple(x) for x in subset.values]
    
    mydb = mysql.connector.connect(
    host="ornus.cwrnsgadkrxd.us-west-1.rds.amazonaws.com",
    user="ornus",
    passwd="ornus_capital88",
    database="ornus"
  
    )
    mycursor = mydb.cursor()

    mycursor.execute("CREATE TABLE daily_count_"+tbl_name+" (recent_dates DATE, count INT)")
    
    
    mydb = mysql.connector.connect(
    host="ornus.cwrnsgadkrxd.us-west-1.rds.amazonaws.com",
    user="ornus",
    passwd="ornus_capital88",
    database="ornus"
  
    )
    
    mycursor = mydb.cursor()

    sql = "INSERT INTO daily_count_"+tbl_name+" (recent_dates, count) VALUES (%s, '%s')"
    val = tuples

    mycursor.executemany(sql, val)

    mydb.commit()
    
    return print("Table Created")

##To refresh the table into current time
##Will only work if one is already created for it.
#Will throw error if the table doesn't already exist

def refresh_daily_count(tbl_name):
    
   mydb = mysql.connector.connect(
   host="ornus.cwrnsgadkrxd.us-west-1.rds.amazonaws.com",
   user="ornus",
   passwd="ornus_capital88",
   database="ornus"
  
    )
   
   mycursor = mydb.cursor()

   sql = "DROP TABLE daily_count_"+tbl_name

   mycursor.execute(sql)
   
   create_daily_count_tbl(tbl_name)
   
   return print("Table Refreshed")

#To Delete the daily count table off the database of SQL

def del_daily_count_tbl(tbl_name):
    
   mydb = mysql.connector.connect(
   host="ornus.cwrnsgadkrxd.us-west-1.rds.amazonaws.com",
   user="ornus",
   passwd="ornus_capital88",
   database="ornus"
  
    )
   
   mycursor = mydb.cursor()

   sql = "DROP TABLE daily_count_"+tbl_name

   mycursor.execute(sql)
   
   return print("Table Deleted")


##-------------------------------------------------------------
   
#NOTES : -Tables should appear in SQL after using the create function


#Examples:             

create_daily_count_tbl("reddit_users")
create_daily_count_tbl("tweets")
create_daily_count_tbl("reddit_posts")

#Go to SQL and use "SHOW TABLES" to see prefixed "daily_count" tables

refresh_daily_count("reddit_users")
refresh_daily_count("tweets")
refresh_daily_count("reddit_posts")


del_daily_count_tbl("reddit_users")
del_daily_count_tbl("tweets")
del_daily_count_tbl("reddit_posts")

