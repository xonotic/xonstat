<%inherit file="base.mako"/>
<%namespace name="nav" file="nav.mako" />

<%block name="navigation">
  ${nav.nav('players')}
</%block>

<%block name="title">
  Active Players Index
</%block>

% if not top_players and start is not None:
  <h2 class="text-center">Sorry, no more players!</h2>

% elif not top_players and start is None:
  <h2 class="text-center">No active players found. Yikes, get playing!</h2>

% else:
  ##### ACTIVE PLAYERS #####
  <div class="row">
    <div class="small-12 large-6 large-offset-3 columns">
      <table class="table-hover table-condensed">
        <thead>
          <tr>
            <th class="small-2">#</th>
            <th class="small-7">Nick</th>
            <th class="small-3">Play Time</th>
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
      <p class="text-center"><small>Note: these figures are from the past 7 days</small>
    </div>
  </div>

% if len(top_players) == 20:
<div class="row">
  <div class="small-12 large-6 large-offset-3 columns">
    <ul class="pagination">
      <li>
        <a  href="${request.route_url('top_players_index', _query=query)}" name="Next Page">Next <i class="fa fa-arrow-right"></i></a>
      </li>
    </ul>
  </div>
</div>
% endif

% endif
