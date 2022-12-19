# WCBN Datasets

To use this repo, it is recommended you install [git-lfs](https://git-lfs.github.com/) to handle versioning large files.

Over the years, there have been a few different databases used by the station.

## Dataset schemas

### `playlist_2004_to_2015.csv`

This is from a legacy MySQL database hosted by umich

| played_at     | song_name        | artist      | album           | label       | dj_name        | show_name       |
| ------------- | ---------------- | ----------- | --------------- | ----------- | -------------- | --------------- |
| 8/24/04 10:53 | Death Valley '69 | Sonic Youth | Bad Moon Rising | Blast First | rotating hosts | NOISE 'TIL NOON |

### `playlist_2015_07_09_to_2021_02_23.csv` and `playlist_2021_02_23_to_2022_09_21.csv`

These are from [readback's](https://www.github.com/wcbn/readback) postgres DB. The original "schema as code" can be found [here](https://github.com/wcbn/readback/blob/master/db/schema.rb). It was queried with a best effort to match the legacy schema.

| played_at                  | song_name | artist         | album     | label            | dj_name        | show_name            |
| -------------------------- | --------- | -------------- | --------- | ---------------- | -------------- | -------------------- |
| 2015-09-17 01:46:31.185372 | Time      | Chris Bathgate | Salt Year | Quite Scientific | rotating hosts | The Local Music Show |

## Contributing

If you have access to a station databse and want to contribute some files, this is the section for you.

### Postgres

Here is an example of how to build a CSV from a postgres DB.

1. `brew install postgres`
2. Get the connection string (including username/pw) for the relevant DB
3. Adjust `readback.sql` as needed
4. `psql <database connection string> -tA -F "," -f readback.sql -o new_readback_playlist.csv`
