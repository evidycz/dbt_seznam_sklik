
# Seznam Sklik dbt Package

This dbt package models data from the Seznam Sklik advertising platform. It transforms raw Seznam Sklik data into a set of dimensional models that can be used for reporting and analysis.

## Overview

The Seznam Sklik dbt package:

- Transforms raw Seznam Sklik data into analytics-ready models
- Creates daily performance metrics at various levels of the advertising hierarchy (account, campaign, ad group, ad, etc.)
- Calculates key advertising metrics like CTR, CPC, CPM, ROAS, and impression share
- Provides a foundation for custom reporting and analysis

## Installation

Add the following to your `packages.yml` file:

```yaml
packages:
  - git: "https://github.com/evidycz/dbt_seznam_sklik.git"
    revision: "0.1.0"
```

## Requirements

- dbt version: >=1.3.0, <2.0.0
- Adapter: Compatible with most SQL-based adapters
- Dependencies:
  - dbt-labs/dbt_utils (>=1.3.0, <1.4.0)
  - dbt-labs/codegen (>=0.13.1, <0.14.0)

## Configuration

This package assumes you have a schema named `evidy_seznam_sklik` with the following tables:
- accounts
- ads_stats
- banners_stats
- campaigns_settings
- groups_stats
- queries_stats
- retargeting_stats

You can override the default database and schema settings via vars in `dbt_project.yml` file:

```yaml
vars:
  seznam_sklik_database: your_database_name
  seznam_sklik_schema: your_schema_name
```
By default, this package runs using your destination and the `seznam_sklik` schema.

## Models

The package creates the following models:

### Source Models
These models are direct representations of the source tables with minimal transformations:
- source_seznam_sklik__accounts
- source_seznam_sklik__ads_stats
- source_seznam_sklik__banners_stats
- source_seznam_sklik__campaigns
- source_seznam_sklik__groups_stats
- source_seznam_sklik__queries_stats
- source_seznam_sklik__retargeting_stats

### Mart Models
These models represent the core entities in the Seznam Sklik advertising platform:

- **seznam_sklik__accounts**: Daily performance metrics at the account level
- **seznam_sklik__campaigns**: Daily performance metrics at the campaign level
- **seznam_sklik__ad_groups**: Daily performance metrics at the ad group level
- **seznam_sklik__ads**: Daily performance metrics at the ad level
- **seznam_sklik__banners**: Daily performance metrics for banner ads
- **seznam_sklik__keywords**: Daily performance metrics for keywords
- **seznam_sklik__search_terms**: Daily performance metrics for search terms
- **seznam_sklik__audiences**: Daily performance metrics for retargeting audiences

Each mart model includes:
- Dimensions (date, IDs, names, statuses)
- Metrics (impressions, clicks, conversions, spend)
- Calculated metrics (CTR, CPC, CPM, ROAS)

#### Disable Search Term Keyword Stats
This package uses `queries_stats` source to generate `keyword_stats` and `search_term_stats` models. 
The generation of these models can be disabled by setting the `seznam_sklik__using_search_term_keyword_stats` variable 
to `false`. Generation of these models is enabled by default.

```yaml
vars:
  seznam_sklik__using_search_term_keyword_stats: False
```

## Macros

The package includes the following macros:

### impression_shares
Calculates impression share metrics based on total impressions and different types of lost impressions.

```sql
{{ impression_shares('impressions', 'miss_impressions', round_to=2) }}
```

### weighted_average
Calculates a weighted average for metrics like ad position.

```sql
{{ weighted_average('ad_position', 'impressions', 'avg_ad_position', round_to=2) }}
```

## Usage

After installing the package, run:

```bash
dbt run --select seznam_sklik
```

To run tests:

```bash
dbt test --select seznam_sklik
```

## Metrics

The package calculates the following key metrics:

- **Impressions**: Number of times ads were shown
- **Clicks**: Number of clicks on ads
- **CTR (Click-Through Rate)**: Clicks divided by impressions
- **CPC (Cost Per Click)**: Cost divided by clicks
- **CPM (Cost Per Mille)**: Cost per thousand impressions
- **Conversions**: Number of conversions
- **Conversion Value**: Total value of conversions
- **Spend**: Total cost of advertising
- **ROAS (Return On Ad Spend)**: Conversion value divided by spend
- **PNO (Podíl Nákladů na Obratu)**: Czech metric similar to Cost/Revenue ratio
- **Impression Share**: Percentage of eligible impressions that were shown
- **Ad Position**: Average position of ads
- **Win Rate**: Auction success rate

For video ads, additional metrics include:
- **Views**: Number of video views
- **View Rates**: Percentage of impressions where viewers watched 25%, 50%, 75%, or 100% of videos
