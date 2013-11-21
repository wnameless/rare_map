[![Gem Version](https://badge.fury.io/rb/rare_map.png)](http://badge.fury.io/rb/rare_map)

rare_map
=============

Relational db to ActiveREcord models MAPper

RareMap can be used for BOTH standalone application & Rails

#### Installation:
```ruby
gem install rare_map
```

Basic RareMap Usage
-------------

#### Standalone:
Create a new rare_map.yml with following lines in the root of your application

#### Rails:
Create a new config/rare_map.yml with following lines in rails

rare_map.yml:
```yaml
  legacy:
    adapter: sqlite3
    database: db/db1.sqlite3

  old_db:
    adapter: mysql2
    host: localhost
    database: db_name
    port: 3306
    username: user
    password: pw
```

Run following command in the root of your application or rails
```
$ raremap
```

Standalone: A demo.rb example is generated for you in the root of your application

RareMap console which is like rails console for standalone app can be run by following command
```
$ raremap console  # or simply run `raremap c`
```

Advanced RareMap Usage
-------------

#### Seperate databases into groups (highly recommended)
```yaml
  her_group:
    -
      db1:
        adapter: sqlite3
        database: db/db1.sqlite3
    -
      db2:
        adapter: sqlite3
        database: db/db1.sqlite3

  his_group:
    -
      db1:
        adapter: sqlite3
        database: db/db3.sqlite3
    -
      db2:
        adapter: sqlite3
        database: db/db4.sqlite3
````

There are benefits by separating databases into groups:

1. Associations are built between databases within a group

2. Group name is treated as a module namespace

3. Models of a group are organized within a folder

If all your data reside in several legacy databases, it is important to build back those associations across databases

If there are 2 or more tables with the same name, giving them group names could avoid naming collision

If there are tons of tables, it is better to organize them well


#### Set up RareMap Options
```yaml
  rare_map_opts:
    foreign_key:
      suffix: fk
      alias:
        abnormal_fk1: table1
        abnormal_fk2: table2
    primary_key:
      table1: abnormal_pk
```

* rare_map_opts[foreign_key][suffix]: If your foreign keys are not ended with 'id', you can specify the suffix you want here
* rare_map_opts[foreign_key][alias]: If naming convention is not followed by some foreign keys, you can list them here
* rare_map_opts[primary_key]: Usually rare_map can identify the primary key of a table, if it fails, please list primary keys here

#### RareMap Options Precedence

You can place rare_map options in 3 ways
```yaml
  rare_map_opts:             # Global options
    ...
  group1:
    -
      rare_map_opts:         # Group options
        ...
    -
      db1:
        ...
  legacy_db:
    adapter: sqlite3
    database: db/db.sqlite3
    rare_map_opts:           # DB options
      ...
```
Precedence: DB > Group > Global


## Copyright

Copyright (c) 2013 Wei-Ming Wu. See LICENSE.txt for
further details.

