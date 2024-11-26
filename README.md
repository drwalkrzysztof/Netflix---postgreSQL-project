# Netflix Movies and TV Shows Data Analysis using postgreSQL 

In this project, I practice my knowledge and answer questions using postgreSQL

## Objective 
 
    Analyze the distribution of content types (movies vs TV shows).
    Identify the most common ratings for movies and TV shows.
    List and analyze content based on release years, countries, and durations.
    Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

Dataset Link: [Netflix Dataset]{https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download}

## Schema

'''sql 

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
'''


