# rake で 2 つの DB に table を作成する。

activerecord をつかって、  
　　2 つの dababase を作成、  
　　それぞれの DB に table を作成、  
　　tabale に初期値を設定  
を行う。

## 実行例：
    $ psql -l
    List of databases
    Name    | Owner | Encoding |   Collate   |    Ctype    | Access privileges
    -----------+-------+----------+-------------+-------------+-------------------
    postgres  | katoy | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 |
    template0 | katoy | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 | =c/katoy         +
    |       |          |             |             | katoy=CTc/katoy
    template1 | katoy | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 | =c/katoy         +
    |       |          |             |             | katoy=CTc/katoy
    (3 rows)

DB の作成、table 追加、内容の表示を行う。

    $ rake dbs:reset
       ... 省略...
       ------- User -----------
    +----+-----------+-----------------------+-------------------------+-------------------------+--------------+
    | id | name      | email                 | created_at              | updated_at              | lock_version |
    +----+-----------+-----------------------+-------------------------+-------------------------+--------------+
    | 1  | USER_0001 | USER_0001@example.com | 2015-03-28 10:03:56 UTC | 2015-03-28 10:03:56 UTC | 0            |
    | 2  | USER_0002 | USER_0002@example.com | 2015-03-28 10:03:56 UTC | 2015-03-28 10:03:56 UTC | 0            |
    | 3  | USER_0003 | USER_0003@example.com | 2015-03-28 10:03:56 UTC | 2015-03-28 10:03:56 UTC | 0            |
    +----+-----------+-----------------------+-------------------------+-------------------------+--------------+
    3 rows in set

    ------- Info -----------
    +----+-----------+--------------+-------------------------+-------------------------+--------------+
    | id | name      | address      | created_at              | updated_at              | lock_version |
    +----+-----------+--------------+-------------------------+-------------------------+--------------+
    | 1  | USER_0001 | address_0001 | 2015-03-28 10:03:57 UTC | 2015-03-28 10:03:57 UTC | 0            |
    | 2  | USER_0002 | address_0002 | 2015-03-28 10:03:57 UTC | 2015-03-28 10:03:57 UTC | 0            |
    | 3  | USER_0003 | address_0003 | 2015-03-28 10:03:57 UTC | 2015-03-28 10:03:57 UTC | 0            |
    +----+-----------+--------------+-------------------------+-------------------------+--------------+
    3 rows in set

    $ psql -l
                                 List of databases
      Name       | Owner | Encoding |   Collate   |    Ctype    | Access privileges
    -----------------+-------+----------+-------------+-------------+-------------------
     db1_development | katoy | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 |
     db2_development | katoy | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 |
     postgres        | katoy | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 |

psql の出力から DATABASE が 2 つできていることがわかる。  
DATABASE を削除する事もできる。  

    $ rake dbs:drop
    I, [2015-03-28T19:15:30.390827 #19395]  INFO -- : ### using AR_ENV = 'development'
    I, [2015-03-28T19:15:31.031286 #19395]  INFO -- : ### dropped database db1_development
    I, [2015-03-28T19:15:31.184972 #19395]  INFO -- : ### dropped database db2_development

    $ psql -l
                              List of databases
       Name    | Owner | Encoding |   Collate   |    Ctype    | Access privileges
    -----------+-------+----------+-------------+-------------+-------------------
     postgres  | katoy | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 |

End of File
