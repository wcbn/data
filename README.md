# WCBN Datasets

To use this repo, it is recommended you install [git-lfs](https://git-lfs.github.com/) to handle versioning large files.

All new data comes from [readback](https://www.github.com/wcbn/readback) now, and you can see what attributes we capture in the [readback database schema file](https://github.com/wcbn/readback/blob/master/db/schema.rb)

## Dataset schemas

### `playlist_2004_to_2015.csv`

This is from a legacy MySQL database hosted by umich

| played_at     | song_name        | artist      | album           | label       | dj_name        | show_name       |
| ------------- | ---------------- | ----------- | --------------- | ----------- | -------------- | --------------- |
| 8/24/04 10:53 | Death Valley '69 | Sonic Youth | Bad Moon Rising | Blast First | rotating hosts | NOISE 'TIL NOON |

### `playlist_2015_07_09_to_2021_02_23.csv`

This is from [readback's](https://www.github.com/wcbn/readback) postgres DB. It was queried with a best effort to match the legacy data schema (see below).

| played_at                  | song_name | artist         | album     | label            | dj_name        | show_name            |
| -------------------------- | --------- | -------------- | --------- | ---------------- | -------------- | -------------------- |
| 2015-09-17 01:46:31.185372 | Time      | Chris Bathgate | Salt Year | Quite Scientific | rotating hosts | The Local Music Show |

## Utility Queries

### Readback data in legacy format

This matches column names, default values, and does some tricks to only reveal real names of DJ's who agreed to that (prefer DJ Name, fallback to `NULL`)

```sql
WITH shows_by_type AS(
select e.id as episode_id, s.name as show_name, e.show_type from episodes e join freeform_shows s on s.id = e.show_id where e.show_type = 'FreeformShow'
UNION ALL
select e.id as episode_id, s.name as show_name, e.show_type from episodes e join specialty_shows s on s.id = e.show_id where e.show_type = 'SpecialtyShow'
UNION ALL
select e.id as episode_id, s.name as show_name, e.show_type from episodes e join talk_shows s on s.id = e.show_id where e.show_type = 'TalkShow'
),

public_dj_names as (
select
djs.id as dj_id,
CASE
WHEN dj_name=NULL AND real_name_is_public=TRUE THEN name
ELSE dj_name
END as dj_name

from djs
)


select
songs.at as played_at,
songs.name as song_name,
songs.artist,
songs.album,
songs.label,
CASE
WHEN shows.show_type='SpecialtyShow' THEN 'rotating hosts'
ELSE public_dj_names.dj_name
END as dj_name,
shows.show_name as show_name

from songs inner join episodes e on songs.episode_id = e.id inner join public_dj_names on e.dj_id = public_dj_names.dj_id join shows_by_type shows on e.id = shows.episode_id order by songs.at ;
```
