require_relative '../../lib/github'
require_relative '../../lib/cache'
require_relative '../../lib/resource'
require 'minitest/spec'
require 'minitest/autorun'

describe 'Resource' do
  it 'should convert markdown to html' do
    Resource.directory = 'spec/content'
    ruby = Resource.fetch(:ruby)
    ruby['in_one_sentence'].must_equal "<p>Swiss-army knife</p>\n"
    ruby['for_beginners'].must_equal %(<p><a href="http://tryruby.org">Try Ruby</a></p>\n)
    ruby['for_experts'].must_equal %(<p><a href="http://rubyweekly.com">Ruby Weekly</a></p>\n)
  end
end

describe 'Github Cache' do
  it 'caches for 2 seconds' do
    cache = GithubCache.new timeout: 2
    github = Github.new
    cache.instance_variable_set('@github', github)
    calls = 0
    github.send(:define_singleton_method, 'most_starred') do |_language|
      calls += 1
    end

    cache.most_starred 'ruby'
    calls.must_equal 1
    cache.most_starred 'ruby'
    calls.must_equal 1
    cache.most_starred 'javascript'
    calls.must_equal 2
    cache.most_starred 'javascript'
    calls.must_equal 2
    sleep 2
    cache.most_starred 'ruby'
    calls.must_equal 3
  end
end

describe 'Github' do
  it 'fetches contributors' do
    github = Github.new
    github.send(:define_singleton_method, 'open') do |_uri, _headers|
      Class.new { def read; $CONTRIBUTORS_DATA; end }.new
    end
    contributors = github.contributors 'matstc/whatsnext.info'
    contributors[0]['login'].must_equal 'matstc'
  end

  it 'fetches most starred repositories' do
    github = Github.new
    github.send(:define_singleton_method, 'open') do |_uri|
      Class.new { def read; $STARRED_DATA; end }.new
    end
    most_starred = github.most_starred 'ruby'
    most_starred.length.must_equal 1
    rails = most_starred[0]
    rails['name'].must_equal 'rails'
    rails['full_name'].must_equal 'rails/rails'
    rails['owner']['avatar_url'].must_equal 'https://gravatar.com/avatar/30f39a09e233e8369dddf6feb4be0308?d=https%3A%2F%2Fidenticons.github.com%2Ff42a37d114a480b6b57b60ea9a14a9d2.png&r=x'
    rails['stargazers_count'].must_equal 20_835
    rails['html_url'].must_equal 'https://github.com/rails/rails'
    rails['description'].must_equal 'Ruby on Rails'
  end
end

$CONTRIBUTORS_DATA = <<EOF
[{"login":"matstc",
"id":58882,
"avatar_url":"https://avatars.githubusercontent.com/u/58882?v=2",
"gravatar_id":"",
"url":"https://api.github.com/users/matstc",
"html_url":"https://github.com/matstc",
"followers_url":"https://api.github.com/users/matstc/followers",
"following_url":"https://api.github.com/users/matstc/following{/other_user}",
"gists_url":"https://api.github.com/users/matstc/gists{/gist_id}",
"starred_url":"https://api.github.com/users/matstc/starred{/owner}{/repo}",
"subscriptions_url":"https://api.github.com/users/matstc/subscriptions",
"organizations_url":"https://api.github.com/users/matstc/orgs",
"repos_url":"https://api.github.com/users/matstc/repos",
"events_url":"https://api.github.com/users/matstc/events{/privacy}",
"received_events_url":"https://api.github.com/users/matstc/received_events",
"type":"User",
"site_admin":false,
"contributions":97},
{"login":"cedricbousmanne",
"id":176837,
"avatar_url":"https://avatars.githubusercontent.com/u/176837?v=2",
"gravatar_id":"",
"url":"https://api.github.com/users/cedricbousmanne",
"html_url":"https://github.com/cedricbousmanne",
"followers_url":"https://api.github.com/users/cedricbousmanne/followers",
"following_url":"https://api.github.com/users/cedricbousmanne/following{/other_user}",
"gists_url":"https://api.github.com/users/cedricbousmanne/gists{/gist_id}",
"starred_url":"https://api.github.com/users/cedricbousmanne/starred{/owner}{/repo}",
"subscriptions_url":"https://api.github.com/users/cedricbousmanne/subscriptions",
"organizations_url":"https://api.github.com/users/cedricbousmanne/orgs",
"repos_url":"https://api.github.com/users/cedricbousmanne/repos",
"events_url":"https://api.github.com/users/cedricbousmanne/events{/privacy}",
"received_events_url":"https://api.github.com/users/cedricbousmanne/received_events",
"type":"User",
"site_admin":false,
"contributions":4},
{"login":"juliawong",
"id":1804284,
"avatar_url":"https://avatars.githubusercontent.com/u/1804284?v=2",
"gravatar_id":"",
"url":"https://api.github.com/users/juliawong",
"html_url":"https://github.com/juliawong",
"followers_url":"https://api.github.com/users/juliawong/followers",
"following_url":"https://api.github.com/users/juliawong/following{/other_user}",
"gists_url":"https://api.github.com/users/juliawong/gists{/gist_id}",
"starred_url":"https://api.github.com/users/juliawong/starred{/owner}{/repo}",
"subscriptions_url":"https://api.github.com/users/juliawong/subscriptions",
"organizations_url":"https://api.github.com/users/juliawong/orgs",
"repos_url":"https://api.github.com/users/juliawong/repos",
"events_url":"https://api.github.com/users/juliawong/events{/privacy}",
"received_events_url":"https://api.github.com/users/juliawong/received_events",
"type":"User",
"site_admin":false,
"contributions":1},
{"login":"slang800",
"id":1049204,
"avatar_url":"https://avatars.githubusercontent.com/u/1049204?v=2",
"gravatar_id":"",
"url":"https://api.github.com/users/slang800",
"html_url":"https://github.com/slang800",
"followers_url":"https://api.github.com/users/slang800/followers",
"following_url":"https://api.github.com/users/slang800/following{/other_user}",
"gists_url":"https://api.github.com/users/slang800/gists{/gist_id}",
"starred_url":"https://api.github.com/users/slang800/starred{/owner}{/repo}",
"subscriptions_url":"https://api.github.com/users/slang800/subscriptions",
"organizations_url":"https://api.github.com/users/slang800/orgs",
"repos_url":"https://api.github.com/users/slang800/repos",
"events_url":"https://api.github.com/users/slang800/events{/privacy}",
"received_events_url":"https://api.github.com/users/slang800/received_events",
"type":"User",
"site_admin":false,
"contributions":1}]
EOF

$STARRED_DATA = <<EOF
{"total_count":514716,
"items":[{"id":8514,
"name":"rails",
"full_name":"rails/rails",
"owner":{"login":"rails",
  "id":4223,
  "avatar_url":"https://gravatar.com/avatar/30f39a09e233e8369dddf6feb4be0308?d=https%3A%2F%2Fidenticons.github.com%2Ff42a37d114a480b6b57b60ea9a14a9d2.png&r=x",
  "gravatar_id":"30f39a09e233e8369dddf6feb4be0308",
  "url":"https://api.github.com/users/rails",
  "html_url":"https://github.com/rails",
  "type":"Organization",
  "site_admin":false},
"private":false,
"html_url":"https://github.com/rails/rails",
"description":"Ruby on Rails",
"url":"https://api.github.com/repos/rails/rails",
"created_at":"2008-04-11T02:19:47Z",
"updated_at":"2014-02-19T10:30:19Z",
"pushed_at":"2014-02-19T10:30:18Z",
"git_url":"git://github.com/rails/rails.git",
"ssh_url":"git@github.com:rails/rails.git",
"clone_url":"https://github.com/rails/rails.git",
"svn_url":"https://github.com/rails/rails",
"homepage":"http://rubyonrails.org",
"size":255351,
"stargazers_count":20835,
"watchers_count":20835,
"language":"Ruby",
"has_issues":true,
"has_downloads":true,
"has_wiki":false,
"forks_count":7398,
"mirror_url":null,
"open_issues_count":713,
"forks":7398,
"open_issues":713,
"watchers":20835,
"default_branch":"master",
"score":1.0}]}
EOF
