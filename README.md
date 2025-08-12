# Amtrak DBMS & Data Analytics Project

This project is a comprehensive database management and analytics solution built around Amtrak operational data. It combines database design, SQL scripting, and visualization using Tableau to extract insights and recommend strategies based on real-world metrics like ridership, guest rewards, staffing, and on-time performance (OTP).

## Project Structure

### DBMS Project

Contains the full SQL backend implementation:

- **`DDL.sql`** – Defines all tables and database schema (Data Definition Language).
- **`DML.sql`** – Sample queries used for analytics and business transactions (Data Manipulation Language).
- **`Inserts.sql`** – Populates the database with cleaned Amtrak data from various sources.

### Reports and Presentations

- **`Design.docx`** – ER diagram explanation, normalization steps, and rationale for schema design.
- **`Report.docx`** – Full project write-up with business problem framing, data sources, insights, and recommendations.
- **`Slides.pptx`** – Summary deck presenting key findings and visuals for stakeholder communication.

### Tableau Dashboard

- **`Tableau_Dashboard.twb`** – Interactive dashboard built in Tableau for state-level KPIs, route performance, and guest reward trends.

## Project Overview

- **Business Context**: Improve Amtrak’s operational efficiency and customer engagement using structured data analysis.
- **Data Sources**: Derived from Amtrak's official state fact sheets (2021–2023), route guides, and public-facing route information.
- **Use Cases**:
  - Rank cities/states by ridership and reward program growth
  - Evaluate route-level OTP performance
  - Create operational efficiency metrics combining staffing and punctuality
  - Recommend targeted strategies for infrastructure and loyalty programs

## Key Tools & Technologies

- **SQL Server** for database implementation
- **Tableau** for data visualization
- **Excel** for initial data cleaning
- **Word & PowerPoint** for documentation and presentation

## How to Use

1. Run `DDL.sql` in your SQL environment to create the schema.
2. Run `Inserts.sql` to populate data into tables.
3. Use `DML.sql` to perform analysis and extract insights.
4. Open the Tableau file to view dynamic dashboards.

## Insights Delivered

- Top cities for Amtrak ridership and potential growth areas
- States showing the highest guest loyalty increase year-over-year
- Operational efficiency scorecard balancing staffing and OTP
- Route-level performance tiers and investment priorities

## References

- [Amtrak State Fact Sheets](https://www.amtrak.com/about-amtrak/amtrak-facts/state-fact-sheets.html)
- [Amtrak Route Details](https://amtrakguide.com/routes/)

---
