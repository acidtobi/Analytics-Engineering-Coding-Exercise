import sqlite3

def execute_sql_from_file(cursor, filename, fetch=True):

    """
    Executes an SQL query stored in a file in an SQlite database

    :param cursor: Cursor for a SQlite database
    :param filename: Name of the file containing the SQL code to be executed
    :return: A nested list with the query results
    """

    with open(filename, 'r') as file:
        query = file.read()

    cursor.execute(query)

    if fetch:
        return cursor.fetchall()
    else:
        return None

## Connect to SQlite database
conn = sqlite3.connect('exercise.db')
cursor = conn.cursor()

## Question 1: What's the total number of users present in the dataset?
print("Question 1")
num_users, = execute_sql_from_file(cursor, "question1.sql")[0]
print("There are %d users in the dataset." % num_users)
print()

## Question 2: List the number of installs per country
print("Question 2")
installs_by_country = execute_sql_from_file(cursor, "question2.sql")
for country, num_installs in installs_by_country:
    print("%-11s: %4d installs" % (country, num_installs))
print()

## Question 3a: How many users installed the app on August 2, 2022 in Germany on Android?
print("Question 3a")
num_users, = execute_sql_from_file(cursor, "question3a.sql")[0]
print("%d users in Germany installed the app on August 2, 2022 in Germany." % num_users)
print()

## Question 3b: How many of these users are active on the first and third day after the install respectively?
print("Question 3b")
num_active_users = dict(execute_sql_from_file(cursor, "question3b.sql"))
print("%d of these users were active on the first day after install." % num_active_users[1])
print("%d of these users were active on the third day after install." % num_active_users[3])
print()

## Question 3c: How much are those in percent?
print("Question 3c")
print("%.2f%% of these users were active on the first day after install." % (100.0 * num_active_users[1] / num_users))
print("%.2f%% of these users were active on the third day after install." % (100.0 * num_active_users[3] / num_users))
print()

## Question 4: Create a view named marketing that provides the following columns per day and per campaign
print("Question 4")
execute_sql_from_file(cursor, "question4.sql", fetch=False)
print()

## Question 5: Query the view marketing and report the Costs per Install (CPI) on August 6, 2022, for campaign “google_campaign1”
print("Question 5")
cpi, = execute_sql_from_file(cursor, "question5.sql")[0]
print("The CPI on August 6, 2022, for campaign google_campaign1 was %.2f" % cpi)
print()

cursor.close()
conn.close()