# PortfolioAdvisor

Application that give investors advices on  their portfolio

## Overview

PortfolioAdvisor will pull atricles from New's API and use crawler to get full content of each article. After that, use text mining to analyze content and caculate their score for each company.

Each company will search 15 article at a time, then it will sum each article's score. The score is an indicator to suggest people which stock they should buy. Also, we will reocrd history score to analyze stock market trend.

# Domain entities
- Target: the company we are searching
- Updated_at: last time of searching the company
- Articles: the corresponding search result of target
- Url: the url of article
- Content: the content of article
- Score: the score after analyze content

## Database 
<pre>
┌─────────────┐1       *┌─────────────┐
│   Target    ├─────────┤   Article   │
└─────────────┘         └─────────────┘
</pre>
<pre>
┌─────────────┐1       *┌─────────────┐
│   Target    ├─────────┤  Histories  │
└─────────────┘         └─────────────┘
</pre>

## Target

- company_name
- array of Article

## Article

- title
- url
- published_at

 
