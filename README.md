#SodaCan

An ActiveRecord-like interface to databases with a JSON based Soda2 interface, and example of which is the NYC OpenData set.

##Usage

A new database should be added to an application by subclassing SodaCan::Base

    class MyDB < SodaCan::Base
    end

This new class comes with a host of query methods out of the box. Before querying the database, connect it to the Soda2 database

    MyDB.connect [uri string here]

##Query Methods

All query methods are class methods on a DB class. Query methods return instances of the DB class, just like ActiveRecord.

###.many

Returns an array of up to the first 1000 instances in the database

###.execute _query_

Returns the instances retrieved as a result of sending the query to the database

###.find _id_

Returns the instance in the database with the given ID, nil if the id is not found

###.search _term_

Returns an array of any instances that have the term string as a value for any field. Search works only for full tokens in the database. "ban" will match "ban on apples" but not "bananas are good"

###.where _params_

Returns an array of instances where the field represented by the key in the params hash has the value represented by the value in the params hash

##Instance methods

###\#\_fields

Returns a hash of field names and types found in the instance

###\#accessors

Depending upon the record being accessed a number of accessor methods are created for the instance, allowing access to the fields.

##Example

    class MyDB < SodaCan::Base
    end

    MyDB.connect 'http://someurl.com/'

    first = MyDB.find 1
    bananas = MyDB.search "banana"
    bananas.first.calories # calorie count of the first banana
    fruit = MyDB.where(food_group: 'fruit')
