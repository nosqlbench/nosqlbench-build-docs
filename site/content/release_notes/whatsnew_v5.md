+++
title = "What's New - NB5"
+++

👉 **The docs are presently being rewritten to support NoSQLBench v5.0.** 👈

Welcome to NB5! This release represents a massive leap forward. There are so many improvements 
that should have gone into smaller releases along the way, but here we are. We've had our heads 
down, focusing on new APIs, porting drivers, and fixing bugs, but it's time to talk about the 
new stuff!

For those who are experienced NB5 users, this will have few (but some!) surprises. For 
those of you who are NB (4 or earlier) users, NB5 is a whole different kind of testing tool. The 
changes allow for a much more streamlined user and developer experience, while also offering 
additional capabilities never seen together in a systems testing tool. 

Everything mentioned here will find its way into the main docs site before were done.

We've taken some care to make sure that there is support for earlier workloads where at all
possible. If we've missed something critical, please let us know and we'll patch it up ASAP.

# A New Artifact - nb5

The main bundled artifact is now named **nb5**.  This version of NoSQLBench is a
significant departure from the previous limitations and conventions, so a new name was fitting.
It also allows you to easily have both on your system if you are maintaining test harnesses.
This is a combination of the NoSQLBench core runtime module `nbr` and all the bundled driver 
adapters which have been contributed to the project.

# Project 

Significant changes were made for the benefit of both users and developers.

We've expanded the developer team which maintains tools like NoSQLBench. This should allow us to 
make improvements faster, focus on users more, and bring more strategic capabilities to the project 
which can redefine how advanced testing is done.

We've connected the integration and specification tests to the documentation in a way that
ties examples everything together. If the examples and integration tests that are used on this 
site fail, the build fails. Otherwise, the most recent examples are auto exported from the main 
code base to the docs site. This means that test coverage will improve examples in the docs, 
which will stay constantly up to date.

# Architecture

The APIs for building drivers have been redesigned from the ground up to support
multiple needs in the user and developer community. The high-level benefits include:

* Vastly simplified driver contributor experience
* Common features across all implemented DriverAdapters
* Interoperability between drivers in the same scenario or activity
* Standard core activity params across all drivers, like `op=...`
* Standard metrics across all drivers
* Standard error handler support
* Standard op template features, like named start and stop timers
* Interoperable data between drivers
* Standard diagnostic tools across all drivers

The amount of _Standard_ you see in this list is directly related to the burden removed from
(first tiem or experienced) driver developers.

These will be elaborated on below, as much of the new functionality in nb5 is directly enabled 
by the new APIs.


# Packaging

The code base for nb5 is more modular and adaptable. The core runtime module `nbr` is now 
separate, including only the core diagnostic driver which is used in integration tests. This allows
for leaner and meaner integration tests.

# Releases

Going forward we'll enforce stricter release criteria. Interim releases will be flagged as
prerelease unless due diligence checks have been done and a peer review finds a prerelease
suitable for promotion to a main release. Once flagged as a normal release, CI/CD tools can pick 
up the release from the github releases area automatically.

We have a set of release criteria which will be published to this site and used as a blueprint for 
releases going forward.

# Docs

This doc site is a significant step up from the previous version. It is now more accessible, 
more standards compliant, and generally more user-friendly. The dark theme is highly usable. 
Syntax highlighting is much easier on the eyes, and page navigation works better! The starting 
point for this site was provided by the [abridge](https://github.com/Jieiku/abridge) theme by 
[Jieiku](https://github.com/Jieiku).

# Core

* The error handler mechanism is now fully generalized across all drivers. It is also chainable, 
  with specific support for handling each error type with a specific chain of handlers, or 
  simply assigning a default to all of them as before.
* The rate limiter is more efficient. This should allow it to work better in some scenarios 
  where inter-core contention was a limiting factor.
* It is now possible to dry-run an activity with `dryrun=true`. This uses all the logic 
  of a normal execution, but it wraps the op implementation in a no-op. The results of this will 
  tell you how fast the client can synthesize and dispatch operations when there is no op 
  execution involved. The measurement will be conservative due to the extra wrapping layer.
* Thread management within activities is now more efficient, more consistent, and more real-time.
  Polling calls were replaced with evented calls where possible. 
* Only op templates which are active (selected and have a positive ratio) are resolved at 
  activity initialization. This improves startup times for large workload with subsets of 
  operations enabled.
* Native Driver (like the CQL Java Driver) and Adapter state is now instanced per unique value of 
  an op field  parameter called `space`. By default, this is wired to return `default`, thus 
  each unique adapter will use the same internal object graph for execution. This is how things 
  worked for most drivers before. However, if the user specifies that the space should vary, 
  then the simply assign it a binding. This allows for advanced driver testing across a number 
  of client instances, either pseudo-randomly or in lock-step with specific access patterns. If 
  you don't want to use this, then ignore it and everything works as it did before.
* The activity parameter `driver` simply sets the default adapter for an activity. You can set 
  this per op template, and run a different driver for every cycle. This field must be static on 
  each op template, however.
* Adapters can be loaded from external jars. This can help users who are building adapters and want 
  to avoid building the full runtime just for iterative testing.
* The phase loop has been removed.
* Operations can now generate more operations associated with a cycle. This opens the door to 
  true emulation of client-side linearized operations which emulate joins and similar patterns.

# Console

* Discovery of bundled assets is now more consistent, supported with a family of `--list-...`
  options.
* You can use `userfile` and `passfile` instead of `username` or `password`. These indirect to a 
  file and simply read their content.
* ANSI color support in some places, such as in console logging patterns. The `--ansi` and 
  `--console-pattern` and `--logging-pattern` options work together. If a non-terminal is 
  detected on stdout, ANSI is automatically disabled.
* The progress meter has been modified to show real-time, accurate, detailed numbers 
  including operations in flight.


# Templating

Much of the power of NB5 is illustrated in the new ways you can template workloads. This 
includes structured data, dynamic op configuration, and driver instancing to name a few:

* All YAML structure is now supported as maps, in addition to the other structural 
  forms. All of these forms automatically de-sugar into the canonical forms for the runtime to 
  use. This follows the previous pattern of "If it does what it looks like, it is valid", but further 
  allows simplification of workloads with inline naming of elements.
* The structure of op templates (the YAML you write to simulate access patterns) has been
  standardized around a strict set of specification tests and examples. These are documented
  in-depth and tested against a specification with round-trip validation.
* Op templates support arbitrary structure instead of just scalar or String values. This is 
  especially useful for JSON payload modeling.
* Op templates now have a generalized templating mechanism that works for all data templating 
  scenarios. You can reference bindings as before, but you can also create collections and 
  string templates by writing fields as they naturally occur, then adding `{bindings}` where you 
  need.
* All op template fields can be made dynamic if an adapter supports it. It is up to the adapter 
  implementor to decide which op fields must be static.
* Op template values auto-defer to configured values as static, then dynamic, and then 
  configured from activity parameters as defaults. If an adapter supports a parameter at the 
  activity level, and an op form supports the same field, then this occurs automatically.
* Tags for basic YAML structure are provided gratis. You no longer need to specify the 
  conventional tags. All op templates now have `block: <blockname>` and `name: 
  <blockname>--<name>` tags added. This works with regexes in tag filtering.
* Named scenarios now allow for `nb5 <workload-file> <scenario-name>.<scenario-step> ...`. You can 
  prototype and validate complex scenarios by sub-selecting the steps to execute.
* You can use the `op="..."` activity parameter to specific a single-op workload on the 
  command line, as if you had read it from a workload YAML. This allows 
  for one-liner tests streamlined integration, and other simple utility usage.
* Binding recipes can now occur inline, as `{{/*Identity()*/}}`. This works with the op 
  parameter above.
* You can now set a minimum version of NoSQLBench to use for a workload. The `min_version: "4.17.
  15"` property is checked starting from the most-significant number down. If there are new core 
  features that your workload depends on, you can use this to avoid ambiguous errors.
* Template vars like `<<name:value>>` or `TEMPLATE(name,value)` can set defaults the first time they 
  are seen. This means you don't have to update them everywhere. A nice way to handle this is to 
  include them in the description once, since you should be documenting them anyway!

# Deprecations and Standards

* NB5 depends on Java 17. Going forward, major versions will adopt the latest LTS java release.
* Dependencies which require shading in order to play well with others are not supported. If you 
  have a native driver or need to depend on a library which is not a good citizen, you can only 
  use it with NB5 by using the external jar feature (explained elsewhere). This includes the 
  previous CQL drivers which were the `1.9.*` and `3.*.*` version. Only CQL driver 4.* is 
  provided in nb5.
* Dependencies should behave as modular jars, according to JPMS specification. This does not 
  mean they need to be JPMS modules, only that the get halfway there.
* Log4J2 is the standard logging provider in the runtime for NoSQLBench. An SLF4J stub 
  implementation is provided to allow clients which implement against the SLF4J API to work.
* All new drivers added to the project are based on the Adapter API.

# Work In Progress

* Linearized Op Modeling
  * We now have a syntax for designating fields to extract from op results. This is part of the 
    support needed to make _client-side joins_ and other patterns easy to emulate.
* Rate Limiter v3
* VictoriaMetrics Integration
  * Labeled metrics need to be fed to a victoria metrics docker via push. This approach will 
    remove much of the pain involved in using prometheus as an ephemeral testing apparatus.



# BELOW THIS LINE IS TBD

* A configuration model for all initial and updatable activity parameters. This allows for more 
  intelligent and useful feedback to users around appropriate parameter usage.

The previous design of NB asked a lot of developers who contributed drivers. This was because 
the original internal framework was based on a "box of components" approach, which was
initially good for experimentation and innovation. However, it did require each 
 

## new Docs
javadoc site
developer guide
first-time-user guide
Ideally:
* imported plugins details
* imported addons details
* imported app details
* imported scenario script details
* imported workload details
* imported format details

## Bundled Scenario Scripts
- stepup
- optimo
- findmax redux

## New command line options
```
--docker-prom-retention-days=183d
--list-scripts
--list-apps
```

## New help topics
## New scripting plugins
- globalvars
- fileaccess
- csvoutput
- shutdown
- s3uploader

## URL support
- s3 (any usage of an S3 URL should work effectively like an equivalent http* URL)

## UX Improvements
- op templates can pull from activity params for some fields
- All yaml can be in mapping form (everything is named)
- All elements in a yaml can have a description field
- Uniform Workload Format
- Uniform Error Handling
* Named Scenario subsections
    - `nb5 namedscenario.yaml`
    - `nb5 namedscenario.yaml default.schema`
    - `nb5 namedscenario.yaml [<name>]`
    - `nb5 namedscenario.yaml <scenarioname>.<stepname>`
* Multiple named scenarios can be chained on the command line, just like any command:
    - `nb5 workloadfile scenario scenario2 scenario3.step1`
- Uniform Workload format
* In-Line Bindings
    - `{bindingname}`
    - `{(NumberNameToString())}`
- anything can be an op template, even a command line option
    - `nb5 run driver=cql op="select * from baselines.keyvalue where foo='{{/*ToString()*/}} limit 
      10"`
* type-safe parameters
    - extraneous parameters are verboten
    - parameter types are adapted as needed or an error is thrown
    - auto-suggested alternatives based on Levenshtein distance
* open-ended binding structures now support multi-layer scaffolding of generated values with a
  mix of static and dynamic values. This means you can write templates for JSON which look like
  the payload you want to send.
    * supports all combinations of lists and maps and strings, with interspersed dynamic values
      for individual elements or as collection generators, with literals, templated strings, or
      direct binding references, and in-line bindings recipes.
* argsfile allows defaults to be set programmatically or on the command line.
* tag filtering conjugates
* auto-injected statement block and statement name tags.
    - this means: You can now construct filters for specific blocks or statements simply by
      knowing their name:
    - `tags=block:schema` or `tags='main-.*'`
* safe usage of activity params and template vars are compatible, but may not be ambiguous. This
  means that if you have a template variable in myworkload.yaml, it must be distinctly named
  from any valid activity parameters, or an error is thrown. This eliminates a confusing source
  of ambiguity.

### Scripting
- scenario.stop(...) now allows regexes for activity aliases


## Core machinery & API Improvements
- dynamic lib loading via jars
- startup logging now captures basic system hardware details and NB version, to assist in
  troubleshooting
- redesigned developer API around op template, op mapper, op dispenser, and parsed op types.
    - This means:
        - ParsedOp - op template -> op mapping -> op dispensing follows an incremental path of
          construction, allowing functional programming methods to be used *only* when needed.
        - This means that you only pay for what you use or change. Op builder methods are only
          added to the construction logic when you need to digress from the defaults.
    * simpler and more powerful API for driver developers
        - consolidated logic into core machinery
        - thin out and focus the driver APIs
        - pick concepts and API terms which are very responsibility focused
            - Op Mapper
            - Op Dispenser
            - ParsedOp (mapping from op templates to native driver calls)
    * support for op generators, or ops that inject other ops into the activity. (LWT
      statement retry, client-side join, etc)
    * Type-And-Target op template convention which represents special op types and their primary
      payload template as a key and value.

- drivers are specified per-op. (The activity param just sets the default)
- native driver contexts, known as a driver `space` allows for instancing native drivers in a data-driven way

## Driver Improvements
* modular diag driver
* cqld4 driver
    * all statement forms are supported
    * allows file or parameter-based configuration
    * some backward support for classic nb5 cql driver options
    * op templates can support any valid statement builder option

## Bundled Applications

Bundled apps have been part of NoSQLBench for some time, but these were mostly used for
behind-the-scenes work, like generating docs for binding functions. Now, these apps are
discoverable and usable by anybody who runs the `--list-apps` command.
These fall into roughly two categories: 1) NB utilities which can be used to slice and dice
test data and 2) driver-specific utilites which are useful when testing or analyzing a specific
type of system.

- `--list-apps`
- `nb5 <appname> -h`
- `nb5 <appname> ...`

### cqlgen

cqlgen - takes schema.cql tablestats -> workload.yaml
- obfuscation
- weighting by op ratios from tablestats
- point to docs ->

sstablegen

* Dry-run mode for all adapter types

review:
- 7578e91d773a9ea8113250899ef46b7aacf95e70
- 392bbcc5954019ae58956850c980646cef14a1f7
- b6627943e2aed2a80ba1aa13d0a929c1ed04b685
- 394580d66c107127cc68f88cdc64a59e9c481d43
- 0330c18a7ba0904b3b3420b94416b04ee73dd7fb
- 11dd8f62daf3d1603b75cdd85fbb872dbfaac111

* For developers
    * New APIs
        * DriverAdapter
        * SpaceCache
        * ParsedOp
        * OpMapper
        * OpDispenser

* Removal of Phases loop
* Some support for console colors
* Logging subsystem improvements

* Discovery Options

* Project Improvements
* Testing and Documentation Methods
    * Literate test examples as documentation
* Integrated test logs are artifacts
* Auto-generated reference docs are not auto-imported
* Major releases are gated by static analysis audits
* We're adding code coverage
* We've added more developers to the project
* Testing Improvements - stability and low-core build systems (gh actions)

* config
    * options can be mutually exclusive, like the thread-local rate and the per-activity rate
