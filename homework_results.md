# Completed Objectives

The following are the objectives I was able to complete with comments and reasons behind my changes.

Due to extreme time constraints with my current job (being on support last week), I was only able to fully complete 4 and partially complete 1 of the 6 objectives.

## Objective: Filtering

* Added helper functions to Homework.Repo to enable:
   * Fuzzy string search based on one or more string fields
   * Date range search for an date field
* Updated GraphQL schemas and resolvers to implement the Repo search functions when desired

The fuzzy search feature is something I've never actually done before, so I was torn between the options of using the database to process the search or the application logic. Although it goes against my norm (which is to leave calculation to the application, which is much easier to scale than a database), I went with the database option. First, it was the fastest and most intuitive to implement, because I was able to leverage pre-existing Postgres functions. Doing the fuzzy search on the application side brought with it questions about how much of a data set to query in order to do an accurate search and what is the performance hit on both the db and te app if I pull back too much.

Just like the fuzzy search, it was easiest and fastest to put the search on the database (adding indexes on the date fields would probably be preferred, but didn't have enough time).

## Objective: Company Schema

* Added database and repo level schemas and APIs
* Related User to Company
* Added GraphQL schema and resolvers
* Added migration scripts to update the database
* Added calculation for available credit (non persisted field)

The available credit is a basic, but isn't scalable. It uses every transaction for every related user. If there was more time, I would have considered having something else, like persisting "lastest transaction id" and the "latest available credit" (perhaps).

## Objective: Database Seeding

This was fairly simple. I only added enough data to be able to use it for the 3rd interview demonstration.

## Objective: Decimals to Integers to Decimals

This was the simplest to implement. To avoid business logic creeping into the data models, the GraphQL resolvers used a money converter util which could convert any given structs "money fields" from floats to integers and back again.

## Objective: Pagination (partially complete)

I wasn't able to complete this one fully due to time, however, I do have a branch on my GitHub repo that has two different patterns implemented.

1. **Limit & Offset** - Although it gets the job done for very simple cases, it's not reliable in a high-traffic system
2. **Key-Set Pagination** - This one was more effective, but made a bit trickier to implement with multi-field searching and total record count (using dynamic search parameters)

To see more visit the [changes on my branch](https://github.com/danrix89/web-homework/blob/objective/pagination/elixir/lib/homework/repo.ex) on GitHub.

---

## Other Thoughts

Knowing the goal of this assignment is to allow me to exhibit all aspects of my skill and experience, I have other thoughts to highlight.

### Bonus Tasks

**Bug with Transactions** - The obvious/immediate bug I could find is that `credit` was not "cast" into the model object from the changeset. However, I would think the bigger bug would actually be that there are both a `debit` and a `credit` field when the negative of one is the positive of the others, so you probably only need one of them (i.e. `debit`). I don't know enough about finance logic though to say if my assumption is accurate.

**Security Issue** - Didn't spot this one, but wasn't really looking for it :(

**Docs** - I added documentation to my own changes, but didn't have enough time to add more to the rest of the already present code.

### Testing

I wasn't able to introduce any tests, however, I'm usually very test-driven, heavily emphasizing unit tests (with the appropriate amount of coverage).

### Elixir

The Elixir learning curve wasn't as difficult as it originally seemed. Once I got the hang of pattern matching and how powerful it is, the rest was mainly just getting used to libraries. I really enjoy the documentation

### Package Structure (`../elixir/homework`)

I'm not yet familiar with idiomatic elixir package structure or conventions used at Divvy (including repo setup). However, if after considering all those things, and I still had some wiggle room left over, I might have explored some opportunities to structure the packages differently. :shrug:

### Soft Deletes

Soft deletes are a topic with good points on either side. Nevertheless, I lean toward having them because I've found them to be incredibly helpful to recover data when systems mistakenly "deletes" it. If I had more time, I would've added a soft-delete mechanism using an indexed `deleted_at` column on each table (much like `inserted_at`).
