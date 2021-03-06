<%inherit file="base.mako"/>

<%block name="title">
  Leaderboard
</%block>

<%block name="hero_unit">
  <div class="text-center">
    <img src="/static/css/img/xonotic-logo.png" />
    % if stat_line is None:
      <p class="statline">Tracking Xonotic statistics since October 2011.</p>
    % else:
      <p class="statline">Tracking ${stat_line|n} since October 2011.</p>
    % endif

    % if day_stat_line is not None:
      <p class="statline">${day_stat_line|n} in the past 24 hours.</p>
    % endif
  </div>
</%block>


##### ACTIVE PLAYERS #####
<div class="row">
  <div class="small-12 large-4 columns">
    <h5>Most Active Players <a href="${request.route_url('top_players_index')}" title="See more player activity"><i class="fa fa-plus-circle"></i></a></h5>
      <table class="table table-hover table-condensed">
        <thead>
          <tr>
            <th class="small-2">#</th>
            <th class="small-7">Nick</th>
            <th class="small-3">Time</th>
          </tr>
        </thead>
        <tbody>
        % for tp in top_players:
          <tr>
            <td>${tp.sort_order}</td>
            <td class="no-stretch"><a href="${request.route_url('player_info', id=tp.player_id)}" title="Go to the player info page for this player">${tp.nick_html_colors()|n}</a></td>
            <td>${tp.alivetime}</td>
          </tr>
        % endfor
        </tbody>
      </table>
  </div>


##### ACTIVE SERVERS #####
  <div class="small-12 large-4 columns">
    <h5>Most Active Servers <a href="${request.route_url('top_servers_index')}" title="See more server activity"><i class="fa fa-plus-circle"></i></a></h5>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th class="small-2">#</th>
          <th class="small-7">Server</th>
          <th class="small-3" title="Total accumulated player time on the server">Time</th>
        </tr>
      </thead>
      <tbody>
      % for ts in top_servers:
        <tr>
          <td>${ts.sort_order}</td>
          <td class="no-stretch"><a href="${request.route_url('server_info', id=ts.server_id)}" title="Go to the server info page for ${ts.server_name}">${ts.server_name}</a></td>
          <td>${ts.play_time_str(max_segments=2)}</td>
        </tr>
      % endfor
      </tbody>
    </table>
  </div>


##### ACTIVE MAPS #####
  <div class="small-12 large-4 columns">
    <h5>Most Active Maps <a href="${request.route_url('top_maps_index')}" title="See more map activity"><i class="fa fa-plus-circle"></i></a></h5>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th class="small-2">#</th>
          <th class="small-7">Map</th>
          <th class="small-3">Games</th>
        </tr>
      </thead>
      <tbody>
      % for tm in top_maps:
        <tr>
          <td>${tm.sort_order}</td>
          <td class="no-stretch"><a href="${request.route_url('map_info', id=tm.map_id)}" title="Go to the map info page for ${tm.map_name}">${tm.map_name}</a></td>
          <td>${tm.games}</td>
        </tr>
      % endfor
      </tbody>
    </table>
  </div>
</div>

<div class="row">
  <div class="small-12 columns">
    <small>*Most active stats are from the past 7 days</small>
  </div>
</div>


##### RECENT GAMES #####
% if len(recent_games) > 0:
<div class="row">
  <div class="small-12 columns">
    <h5>Recent Games <a href="${request.route_url('game_index')}"><i class="fa fa-plus-circle"></i></a></h5>
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th class="small-1 text-center"></th>
          <th class="small-1">Type</th>
          <th class="show-for-medium-up small-3">Server</th>
          <th class="show-for-medium-up small-2">Map</th>
          <th class="show-for-large-up small-2">Time</th>
          <th class="small-3">Winner</th>
        </tr>
      </thead>
      <tbody>
      % for rg in recent_games:
        <tr>
          <td class="text-center"><a class="button tiny" href="${request.route_url('game_info', id=rg.game_id)}" title="View detailed information about this game">view</a></td>
          <td class="text-center"><span class="sprite sprite-${rg.game_type_cd}" alt="${rg.game_type_cd}" title="${rg.game_type_descr}"></span></td>
          <td class="show-for-medium-up no-stretch"><a href="${request.route_url('server_info', id=rg.server_id)}" title="Go to the detail page for this server">${rg.server_name}</a></td>
          <td class="show-for-medium-up"><a href="${request.route_url('map_info', id=rg.map_id)}" title="Go to the map detail page for this map">${rg.map_name}</a></td>
          <td class="show-for-large-up"><span class="abstime" data-epoch="${rg.epoch}" title="${rg.start_dt.strftime('%a, %d %b %Y %H:%M:%S UTC')}">${rg.fuzzy_date}</span></td>
          <td class="no-stretch">
            % if rg.player_id > 2:
            <a href="${request.route_url('player_info', id=rg.player_id)}" title="Go to the player info page for this player">${rg.nick_html_colors|n}</a></td>
            % else:
            ${rg.nick_html_colors|n}</td>
            % endif
        </tr>
        % endfor
        </tbody>
    </table>
  </div>
</div>
% endif
