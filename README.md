# Netflix_Content_Analysis_Project
![Netflix logo](https://github.com/Atmesh-Tiwari/Netflix_Content_Analysis_Project/blob/main/N_Logo_Alpha.png)

## Problem Statement
As part of netflix's ongoing efforts to optimize our global content strategy and better align with viewer preferences, the Content Strategy team is seeking a comprehensive analysis of the Netflix content library. The task is to explore and uncover actionable insights from our content catalog across dimensions such as content type, ratings, genres, regional performance, and key contributors (directors, actors).

We are particularly interested in understanding the following:

- Content Type Distribution: How is our catalog divided between Movies and TV Shows? This helps us assess content strategy balance.

- Audience Ratings Patterns: What are the most common ratings, and how do they vary between content types? This will assist in aligning acquisitions and production with target demographics.

- Content Availability by Geography: Which countries dominate our catalog, and how does India's release pattern compare over time?

- Influential Contributors: Who are the most frequent directors and actors, particularly in the Indian market? This aids talent partnerships and localization strategy.

- Keyword-Based Sentiment Categorization: Can we flag content as potentially sensitive based on themes like “kill” or “violence”?

- Content Lifecycle and Trends: What is the age of our catalog? Are we adding more recent content, and how frequently?

- Genre and Format Trends: What are our strongest genres? How do season lengths of TV Shows vary?

## Objectives & Deliverables

Conduct an exploratory data analysis (EDA) using the provided Netflix dataset. Your SQL-driven insights should help answer strategic questions across content distribution, genre dominance, audience suitability, geographic preferences, and contributor influence. This will directly support decisions related to content acquisition, recommendation optimization, and regional strategy development.

- Clear, concise SQL queries addressing each business problem
- Summary of findings with charts or tables (if applicable)
- Key recommendations based on the insights
- Highlight any data limitations or improvement suggestions

## Dataset 
![dataset link](https://www.kaggle.com/datasets/shivamb/netflix-shows)

## Schema

'''sql
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
);'''
