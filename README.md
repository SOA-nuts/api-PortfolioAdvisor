# PortfolioAdvisor Web API

Web API that give investors advices on their portfolio

## Routes

### Root check

`GET /`

Status:

- 200: API server running (happy)

### Analyze a previously stored target

`GET /target/{company_name}`

Status

- 200: analyze returned (happy)
- 404: target not found (sad)
- 500: problems finding company data (bad)

### Store a target for analyze

`POST /target/{company_name}`

Status

- 201: target stored (happy)
- 404: no articles found on Google News (sad)
- 500: problems storing the target (bad)

### Show the previouly analyzed history of the company

`GET /history/{company_name}`

Status

- 200: history returned (happy)
- 404: no histories found (sad)
- 500: problems finding history data (bad)