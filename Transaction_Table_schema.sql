/*This database offers a comprehensive framework for analyzing credit card transactions, integrating key tables for cardholder information, 
credit card details, merchant profiles, categories, and transaction records. 
Stakeholders can derive insights into spending patterns, popular merchants, and transaction volumes over time, 
enabling strategic decision-making, risk mitigation, and business growth*/

--Creating Schema of tables for cardholders, credit card details, merchants, merchant categories, and transaction records.

--Card Holder Table

CREATE TABLE "card_holder" (
    "id" INT   NOT NULL,
    "name" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_card_holder" PRIMARY KEY ( "id")
);

-- Credit Card Table

CREATE TABLE "credit_card" (
    "card" VARCHAR(20)   NOT NULL,
    "id_card_holder" INT   NOT NULL,
    CONSTRAINT "pk_credit_card" PRIMARY KEY ("card")
);

-- Merchant Table

CREATE TABLE "merchant" (
    "id" INT   NOT NULL,
    "name" VARCHAR(255)   NOT NULL,
    "id_merchant_category" INT   NOT NULL,
    CONSTRAINT "pk_merchant" PRIMARY KEY ("id")
);

-- Merchant Category Table

CREATE TABLE "merchant_category" (
    "id" INT   NOT NULL,
    "name" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_merchant_category" PRIMARY KEY ( "id")
);

-- Transactions Table

CREATE TABLE "transactions" (
    "id" INT   NOT NULL,
    "date" DATETIME   NOT NULL,
    "amount" FLOAT   NOT NULL,
    "card" VARCHAR(20)   NOT NULL,
    "id_merchant" INT   NOT NULL,
    CONSTRAINT "pk_transactions" PRIMARY KEY ("id")
);



---Adding Constraint and dropping column using alter table command



ALTER TABLE "credit_card" ADD CONSTRAINT "fk_credit_card_id_card_holder" FOREIGN KEY("id_card_holder")
REFERENCES "card_holder" ("id");

ALTER TABLE "credit_card" ADD CONSTRAINT "check_credit_card_length"  CHECK (len("card") <= 20);

--ALTER TABLE "credit_card" DROP CONSTRAINT check_credit_card_length

ALTER TABLE "merchant" ADD CONSTRAINT "fk_merchant_id_merchant_category" FOREIGN KEY("id_merchant_category")
REFERENCES "merchant_category" ("id");

ALTER TABLE "transactions" ADD CONSTRAINT "fk_transactions_card" FOREIGN KEY("card")
REFERENCES "credit_card" ("card");

ALTER TABLE "transactions" ADD CONSTRAINT "fk_transactions_id_merchant" FOREIGN KEY("id_merchant")
REFERENCES "merchant" ("id");