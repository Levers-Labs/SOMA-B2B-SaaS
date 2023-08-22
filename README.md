# SOMA: B2B SaaS
## What is SOMA

SOMA is an open-source, community-driven approach towards **Standard Operating Metrics & Analytics**.

This project exists to make it easy for companies to define, create, and work with operating metrics.

SOMA does this by providing:
* Specifications for naming, defining, and structuring metrics;
* Specifications for the data models and telemetry that support those metrics; 
* Scripts and semantic layer definitions to support the caching and presentation of those metrics; and
* Samples of standard analytics to be performed with those metrics.

## Why

We believe:



* **Metrics are _what_ matters.** For most companies, most of the value of data will come from answering the 4 Fundamental Questions of Analytics:
    1. What happened or is happening in my business?
    2. Why did it happen?
    3. What’s going to happen?
    4. What should or could we do next?

    Answering those questions effectively and quickly requires a company to have <span style="text-decoration:underline;">enough</span> of the <span style="text-decoration:underline;">right</span> metrics. The <span style="text-decoration:underline;">right</span> metrics are easy to understand, easy to benchmark, and effectively proxy the health of underlying business processes. Having <span style="text-decoration:underline;">enough</span> of these means having coverage over all the critical processes within the business.


    Having the <span style="text-decoration:underline;">right</span> metrics helps a company see reality clearly; having <span style="text-decoration:underline;">enough</span> helps a company see reality completely.

* **For the most part, companies shouldn’t be innovating on metrics.** Companies that share a business model (e.g. B2B SaaS) are largely the same in how they operate. And yet, the metrics, data models, visualizations, and analyses that support these companies are largely bespoke.

    Sometimes, there are good reasons for this wheel-reinventing. Most of the time, though, we see this work as arbitrary uniqueness and a misallocation of scarce data resources.


    Instead, we believe that businesses can address the lion's share of their analytics needs by coupling their metrics and analytical use cases to common, open, industry standards.


    The central hope of the SOMA project is that standardizing more of the undifferentiated heavy lifting that companies take on with respect to data can help those companies instead focus on the differentiated work that builds real competitive advantage.



## Domains

SOMA standards are organized under Domains. This repo is concerned with the B2B SaaS domain. The other Domains currently under development are B2C SaaS, ECommerce, Marketplaces, and Logistics.


## Approach

Metrics are the heart of SOMA. The list of metrics, their definitions, and metadata are our <span style="text-decoration:underline;">starting point</span>.

In _developing_ SOMA, we spend most of our energy getting the metrics right. From there, we work backwards to define the upstream telemetry and data models, and forwards to define the downstream reporting and analyses – and all _vis-a-vis_ the metrics.

Likewise, in _using_ SOMA, users are advised to start by selecting an anchor set of metrics and working backwards and forwards to support the development and use of that metric set.

We think many companies get this wrong and their resulting data ecosystems are either volatile, difficult to manage, or are slow to develop. Metrics are rightfully the core primitive of the entire data ecosystem. Metrics must come first – and all other primitives, pipelines, and artifacts derive from those metrics.


## Footprint

The full footprint of SOMA is distributed across four Scopes.

<img width="576" alt="image" src="https://github.com/Levers-Labs/SOMA-B2B-SaaS/assets/7999511/04f68a05-6540-450d-96e7-8c7c8e8b6501">



### Definitions

The Definitions Scope expresses the logical definitions, semantics, and metadata for Metrics and key business Terms and concepts. Definitions are the heart of SOMA.


### Models

The Models Scope specifies foundational data models and telemetry that support the generation of the SOMA Metrics in the Definition Layer.

Unlike other approaches to automating the generation of metrics, SOMA does not work directly with “raw” data from, or as represented in, source systems. While we believe that there is much arbitrary uniqueness in how companies define metrics, we also recognize that source systems are set up and used in highly unique ways and that this heterogeneity requires that raw data first be “mapped” to standard abstractions.

SOMA specifies two types of abstractions: Activities and Entities.


#### Activities

Activities are business events represented as data.

SOMA identifies the set of business events that are relevant for the generation of Metrics and specifies the semantics, structure, metadata, and trigger conditions for Activities that should be “raised” to represent those events.

**[Sample Activity Diagram]**

These activities are “raised” into, and managed in, Activity Streams – which are simply tables in a data warehouse. Activity Streams are append-only, immutable ledgers.

Activities can be “raised” into Activity Streams in two ways:



1. Directly from source systems as the relevant events transpire; or
2. Data pipelines (one pipeline per Activity) increment synthetic events into Activity Streams using source system data already available within the data warehouse.

 \
This pattern has considerable overlap with Narrator’s Activity Schema, though takes a more prescriptive and portable (that is, usable broadly outside of Narrator) approach to specifying the content of Activity Streams.

Activities are SOMA’s recommended modeling abstraction. Relative to alternatives, we believe that using Activities as a primary abstraction:



1. Provides a significantly more intuitive interface for reasoning about and understanding a business;
2. Affords greater auditability and composability;
3. Produces data pipelines that are easier to understand and manage;
4. Lowers the friction for interleaving business events with important telemetry from marketing analytics and product analytics.


#### Entities

Entities are specifications for wide facts and dimension tables. Entities are structurally similar to dimension tables in classical dimensional modeling, though with greater denormalization. These Entities are meant to augment and not replace existing constellations of models in company data warehouses.

SOMA provides specifications for the structure and semantics of these Entities that users can use to author pipelines. For users that are using Activities, SOMA provides SQL scripts that can generate Entities from Activity Streams.


### Expression

The Expression Scope provides users with the selection of two types of interfaces to _express_ Metrics and make them available for consumption.


#### Semantic Layers

Semantic Layers like LookML, Cube, Metricflow, AtScale, etc. provide a virtual abstraction layer for companies to unify metric definitions and semantics. Concretely, SOMA provides “view” files/scripts that express Metrics and Terms that can be copied over into a company’s existing BI-native (e.g. LookML) or transformation-native (e.g. Cube) Semantic Layer.


#### Nets

Nets are tables with the cached measurements for metrics pre-computed across key dimensions.

They are essentially “flattened” OLAP cubes (“net” is a SOMA pun that is bad enough that it requires explanation: a cube projected in 2D space is called a “net”). Nets support faster retrieval and more portability relative to Semantic Layers.

<img width="575" alt="image" src="https://github.com/Levers-Labs/SOMA-B2B-SaaS/assets/7999511/bab879ac-3a8a-487e-9c34-21ab6bb5d113">

For users that want to use Nets, SOMA provides SQL scripts that generate SOMA Metrics from Entities and Activities in the Mapping Layer. These scripts can then be brought into an orchestration or transformation tool.

Note: those scripts must be configured to _increment_ into Nets which, like Activity Streams, are immutable ledgers. 

The ledger design allows Nets to support the bi-temporal nature of metrics. That is, *on* Jan 2nd, we may believe the churn rate *for* Jan 2nd is 20%, but on Jan 4th, we may come to believe (e.g. because of late-arriving facts, data quality issues, or changes in definitions) that the value is 12%. This would be reflected with new Nets entries that have new Measurement Dates for prior Metric Dates.


### Consumption

The Consumption Scope pertains to the “last mile” where Metrics are consumed, shared, and analyzed. Exposures are the “A” in SOMA, and are represented by templates for standard dashboards, visualizations, and analyses.


# Governance


## Committees

SOMA is governed by committee, with each Domain having its own corresponding committee of SMEs, operators, and data and finance practitioners.

SOMA is intended to evolve in response to feedback from users and changes in operating norms for companies, which may lead to Metrics being added, modified, or archived.

Domain Committees meet monthly to review proposed changes and formally version the standard and its specifications if necessary.


## Contribute

Users that would like to contribute back to SOMA may do so in the Domain Github Repos, like this one.

Contributors are requested to raise Pull Requests for proposed edits to SQL scripts and Issues for suggested additions, edits, and deletions to other specifications.


## Domain Statuses

<img width="583" alt="image" src="https://github.com/Levers-Labs/SOMA-B2B-SaaS/assets/7999511/b92d118e-d8b0-499c-9c7f-a30663a711f5">
