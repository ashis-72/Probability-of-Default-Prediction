CREATE TABLE stg_credit_card_clients (
    id INTEGER PRIMARY KEY,
    limit_bal INTEGER,
    sex SMALLINT,
    education SMALLINT,
    marriage SMALLINT,
    age SMALLINT,

    pay_0 SMALLINT,
    pay_2 SMALLINT,
    pay_3 SMALLINT,
    pay_4 SMALLINT,
    pay_5 SMALLINT,
    pay_6 SMALLINT,

    bill_amt1 INTEGER,
    bill_amt2 INTEGER,
    bill_amt3 INTEGER,
    bill_amt4 INTEGER,
    bill_amt5 INTEGER,
    bill_amt6 INTEGER,

    pay_amt1 INTEGER,
    pay_amt2 INTEGER,
    pay_amt3 INTEGER,
    pay_amt4 INTEGER,
    pay_amt5 INTEGER,
    pay_amt6 INTEGER,

    default_payment_next_month SMALLINT
);

---------- Importing Dataset -----------

