# SOMA B2B SaaS dbt project

## What is SOMA
SOMA stands for **S**tandard **O**perating **M**etrics & **A**nalytics. It's a standard set of metrics and practices for using analytics in any company. The SOMA B2B SaaS (this package) is specific to B2B SaaS businesses.

### The SOMA philosophy
SOMA is built on top of the following key insights:

1. **Companies are not unique.** There's too much arbitrary uniqueness in companies. An analyst can switch from a B2B SaaS company to another B2B SaaS and still has to learn the specifics of each one. That is unnecessary! We believe that metrics standardize to the business model. All B2B companies share the same (or mostly the same) metrics for customer acquisition, growth accounting, sales, customer support, etc. Why reinvent the wheel every time when you can start with a known and trusted playbook?

2. **Metrics are the key primitives.** When it comes to measuring the performance of a B2B SaaS business, or any business for that matter, the key is metrics. Unlike many other attempts at standardizing analytics, we start top down with the metrics and move down towards source data vs starting with source data and moving bottom up towards metrics. The key benefit is that modeling becomes a lot easier. Once you map your raw source data to our Immutable Activity Layer, you get all the metrics for free.

3. **Businesses are made up of immutable activities.** Another key insight to our approach simplifies modeling raw data into simple immutable activities and reporting entities. The metrics then hang on these activities. This middle layer has tremendous benefits in transforming arbitrary source data into a standard layer that can simultaneously act as a "data contract", documentation for the business model, and a trusted customer 360. Since the data is assumed to be immutable, this layer is append only thus acting as a trusted source of truth.

### SOMA for B2B SAAS
## About this repo
### Activity Schema

Try running the following commands:
- dbt run
- dbt test
