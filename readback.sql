COPY (
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
  from songs inner join episodes e on songs.episode_id = e.id inner join public_dj_names on e.dj_id = public_dj_names.dj_id join shows_by_type shows on e.id = shows.episode_id order by songs.at
) TO STDOUT WITH CSV HEADER;
