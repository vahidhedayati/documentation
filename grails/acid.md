## ACID:


####Atomicity 
Specifies that all operations within a single transaction must complete together or not at all. In other words, a transaction allows multiple database operations to be applied together. In the event of an error, the entire set of operations is rolled back.


####Consistency 
Refers to the requirement that transactions must transition a database from one consistent state to another consistent state. A successful transaction cannot leave the database in a state that violates the integrity constraints of the database or the schema. In other words, transactions must comply with database constraints and referential integrity rules during every insert, update or delete before a transaction may be committed.


####Isolation 
Defines the rules about how one running transaction affects or interacts with other concurrently running transactions. The isolation strategy used on a transaction is very important. If the chosen isolation level is too loose, hard-to-find bugs can be introduced, which may adversely impact the integrity of your data. If your isolation level is too high, however, you run the risk of slowing down your application or deadlocking your database. This setting is both application server and database server dependent. While there are technically eight isolation levels, generally you will only need to concern yourself with the four that are defined by the ANSI/ISO SQL standard. You should also note that the default isolation level varies quite a bit amongst DBMS vendors.


####Durability 
Ensures that once a transaction is committed, the changes will not be lost and should survive database failures.




## Transactional Annotations

Using the @Transactional annotation, you can set some transactional behavior and attributes. Propagation defines the transactional behavior for the specified method. This setting determines whether a new transaction should always be created, whether a nested transaction should be created, or even if no transaction should be created at all. Here are the Propagation values you can use in Spring: 
```
REQUIRED: If there’s a transaction, support it; otherwise, create a new one.
SUPPORTS: If there’s a transaction, it will be supported, but this is not a requirement.
MANDATORY: There must be a transaction; otherwise, throw an exception.
REQUIRES_NEW: Create a new transaction and suspend the current one if it exists.
NOT_SUPPORTED: Execute the code within the “transactionalized” method non-transactionally and suspend the current transaction.
NEVER: Throw an exception if a transaction exists.
NESTED: Perform a nested transaction if a transaction exists; otherwise, create a new transaction. Nested transactions offer a way to provide more granular transactional behavior, allowing a group of inner transactions to be executed. This can be useful, for example, for cases in which some nested transactions may get rolled back, but without aborting the entire operation. 
```

Isolation is the “I” in ACID, and defines how a running transaction affects (and is affected by) other database processes occurring within the application. The settings to control isolation behavior for a given transaction are:
```
DEFAULT: Let the datastore define the isolation level.
READ_UNCOMMITTED: This isolation level allows changes made by other running
transactions to be read by the actively running transaction, even when the other
transactions have not committed. In other words, this setting enables dirty reads.
READ_COMMITTED: Dirty and nonrepeatable reads are not allowed, but phantom reads are. Only changes applied by successfully committed transactions are visible.
REPEATABLE_READ: Indicates that dirty reads and nonrepeatable reads are prevented but phantom reads may occur.
SERIALIZABLE: Indicates that dirty reads, nonrepeatable reads and phantom reads are prevented.
```
