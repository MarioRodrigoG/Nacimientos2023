# Nacimientos México 2023

This repository contains the Mexico Births 2023 analysis project, leveraging SQL for ETL and data quality checks, and Power BI for interactive reporting.
## Project Structure
```
Nacimientos2023/ # Root folder
├── powerbi/ # Power BI reports
│ └── Nacimientos2023.pbix # Main Power BI dashboard
│
├── sql/ # SQL scripts for ETL and QA
│ └── docs/ # Organized SQL documents
│ ├── 01_TableCreations.sql # Create staging, final, and dim tables
│ ├── 02_DataQualityCheck.sql # Run data quality queries
│ ├── 03_CleaningAndTransformations.sql # Clean and transform data
│ └── 04_MoreDimTables.sql # Create dimentional tables for data modeling. 
│
└── README.md # Project overview and instructions
```

##  Quick Start
### Prerequisites

- SQL Server Express or higher

- Power BI Desktop

- Git

- Dataset **Registros de Nacimientos 2023 (62.4 Mb) **

- https://www.datos.gob.mx/dataset/registro_nacimientos/resource/a9cc472d-4c3f-4e3b-9c3f-89141385318c

### Setup Steps

 #### 1. Clone the repo
 `git clone https://github.com/MarioRodrigoG/Nacimientos2023.git
cd Nacimientos2023`
#### 2. Prepare database

- Open SQL Server Management Studio (SSMS)
- Run `sql/docs/01_TableCreations.sql` to create schemas and tables

#### 3. Load and clean data

Execute `sql/docs/02_DataQualityCheck.sql` to assess raw data quality

Execute `sql/docs/03_CleaningAndTransformations.sql` to populate `Nacimientos_Final`

Execute `sql/docs/04_MoreDimTables.sql` to define dimentional tables that will be used on PBI for mata modeling. 

#### 4. Open and refresh Power BI report

- Launch powerbi/Nacimientos2023.pbix in Power BI Desktop
- Update the data source credentials to your SQL Server instance
- Refresh all data




###Power BI Report Pages
- **Overview:** Key national KPIs and summary cards

- ** Geography:** Choropleth map of births by state

- **Demographics:** Mothers profile (age, indigenous status, education)

- **Service & Logistics:** Travel times, CLUES performance, maternal mortality

- **Temporal Trends:** Monthly, and cumulative birth trends

- **Data Quality**: Outlier counts, completeness flags, QA metrics

### Key Metrics
- **Total Births**

- **% Indigenous**

- **Average Mothers Age**

- **% Maternal Survival**

- **Outlier Detection** on weight & height

- **Average Travel Time** by state & CLUES

### Contributing
1. Fork this repository

3. Create a feature branch `git checkout -b feature/YourFeature`

5. Commit your changes `git commit -am 'Add feature'`

7. Push to the branch `git push origin feature/YourFeature`

9. Open a Pull Request

### License

This project is licensed under the MIT License. See the [LICENSE ](https://opensource.org/license/mit "LICENSE ")file for details. 
