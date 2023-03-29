# SOMA: B2B SaaS

## What is SOMA
SOMA is an approach towards **S**tandard **O**perating **M**etrics & **A**nalytics. Think GAAP, but for operating metrics. Unlike GAAP, SOMA specifies both how metrics and analytics should be defined and also provides a streamlined framework for generating them. SOMA is community-driven, open-source, and will remain so forever. The SOMA B2B SaaS (this package) is specific to B2B SaaS businesses.

### SOMA Design

#### Tenets
SOMA is founded on 3 key tenets:

1. **Companies are not unique.** Companies that share a business model are largely the same in how they operate. SaaS is SaaS is SaaS (marketplaces are marketplaces are marketplaces, etc...). And yet, the metrics, data models, visualizations, and analyses that support these companies are largely bespoke. We believe this is arbitrary uniqueness and a misallocation of scarce data resources. Instead, we believe that businesses can address the lion's share of their analytics needs by coupling their metrics and analytical use cases to common, industry-tested, standards. We are hopeful this enables data teams to create truly differentiated value by focusing their efforts on what makes their companies unique.

2. **Metrics are the key primitive in the data ecosystem.** We believe metrics can be among the most durable concepts in a company, and more durable than the concepts that underly them. What "Customer" means within a company may change, but "Churn", if well-defined, is robust to these changes. Unlike other attempts at standardizing analytics, we anchor on metrics and orient the rest of our thinking around supporting those metrics.

3. **Businesses are made up of activities.** Businesses can be described as sets of activities. Some of those activities are performed by the companies themselves; some of those activities are performed by customers. We believe reasoning about a business as a set of activities is significantly more intuitive than, say, thinking about a business as a set of relational tables, and significantly easier to model.

#### Architecture
<img width="616" alt="image" src="https://user-images.githubusercontent.com/7999511/228596176-42ea61f0-9278-4cd9-ba80-4ea52a451c6e.png">

The architecture of SOMA is designed on the tenets above and specifies standards across 4 layers:

1. Metrics: SOMA defines 209 metrics we find to be most critical to understanding the performance of a B2B SaaS company. For each Metric, we also provide key metadata to support the analysis of that metric.

2. Activities: SOMA sees a B2B SaaS business as a set of 109 semantic activities, e.g., "Customer Renews Contract". SOMA specifies each activity, along with trigger conditions and key metadata. SOMA users then "raise" these activities as events into an immutable ledger.

3. Entities: Entities are wide, dimensional tables that represent unique business concepts. These entities are similar to dimension tables in classical dimensional modeling. Entities are generated automatically through dbt packages and from the ledger of Activities.

4. Nets. Nets are essentially a flattened cube. SOMA precomputes each metric, across every relevant grain, and every period. These precomputations are performed by dbt models and persisted in a dedicated output table.

SOMA 

### SOMA for B2B SAAS
## About this repo
### Activity Schema

Try running the following commands:
- dbt run
- dbt test
