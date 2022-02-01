# Completed Objectives

The following are the objects I was able to complete with reasons behind my changes.

## Objective 1: Filtering

### Fuzzy String Search (with multiple columns)

The fuzzy search feature is something I've never actually done before, so I was torn between the options of using the database to process the search or the application logic. Although it goes against my norm (which is to leave calculation to the application, which is much easier to scale than a database), I went with the database option. First, it was the fastest and most intuitive to implement, because I was able to leverage pre-existing Postgres functions. Doing the fuzzy search on the application side brought with it questions about how much of a data set to query in order to do an accurate search and what is the performance hit on both the db and te app if I pull back too much.

### Date Range Search

DONE

Just like the fuzzy search, it was easiest and fastest to put the search on the database (taking into consideration placing indexes on the date fields).

## Objective 2: Company Schema

DONE

## Objective 3: Database Seeding

DONE

## Objective 5: Pagination



## Objective 6: Decimals to Integers to Decimals

DONE

---

## Other Thoughts

Knowing the goal of this assignment is to allow me to exhibit all aspects of my skill and experience, I have other thoughts to highlight.

### Package Structure (`../elixir/homework`)

I'm not yet familiar with idiomatic elixir package structure or conventions used at Divvy (including repo setup). However, if after considering all those things, and I still had some wiggle room left over, I might have explored some opportunities to structure the packages differently.

### Soft Deletes

Soft deletes are a topic with good points on either side. Nevertheless, I lean toward having them because I've found them to be incredibly helpful to recover data when systems mistakenly "deletes" it. If I had more time, I would've added a soft-delete mechanism using an indexed `deleted_at` column on each table (much like `inserted_at`).
