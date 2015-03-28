# coding: utf-8

require 'logger'

Log = Logger.new(STDOUT)

task default: [:spec]

# yardsettings
require 'yard'
require 'yard/rake/yardoc_task'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['src/**/*.rb', '-', 'Design.md']
  t.options = []
  t.options << '--debug' << '--verbose' if $trace
end

# clear
desc 'Delete coverage/* doc/* tmp/* **/#* **/*~'
task :clean do
  system 'rm -fr coverage */*/coverage'
  system 'rm -fr doc/* */*/doc/*'

  Dir.glob('**/*~').each { |f| FileUtils.rm f }
  Dir.glob('**/#*').each { |f| FileUtils.rm f }
end

# spec
desc 'run spec'
task :spec do
  system 'rspec spec'
end

desc 'metrics'
task :metrics do
  system 'metric_fu'
end

desc 'checkstyle using rubocop.'
task :checkstyle do
  # system 'rubocop -r rubocop/formatter/checkstyle_formatter --format Rubocop::Formatter::CheckstyleFormatter --out tmp/checkstyle.xml lib'
  system 'rubocop lib'
end

# ActiveRecord
# =============================================
namespace :dbs do
  require 'active_record'
  require 'active_record/fixtures'
  require 'yaml'
  require 'hirb'
  require 'hirb-unicode'
  require 'erb'

  Dir.glob('lib/models/*.rb').each { |f| require "./#{f}" }

  class User < ActiveRecord::Base
  end

  class Info < ActiveRecord::Base
  end

  def get_env()
    env = ENV['AR_ENV']
    env = 'development' if env == '' || env.nil?
    env
  end

  # --------- create database ---------------
  desc 'create database "db1_{AR_ENV}", "db2_#{AR_ENV}"'
  task create: [:create_db1, :create_db2] do
  end

  desc 'create database "db1_{AR_ENV}"'
  task create_db1: [:connect_db1] do
    config = ActiveRecord::Base.configurations
    if config['db1']['adapter'] == 'postgresql'
      db = config['db1']['database']
      config['db1']['database'] = 'postgres'
      ActiveRecord::Base.establish_connection config['db1']
      config['db1']['database'] = db
      ActiveRecord::Base.connection.create_database config['db1']['database']
    end
    Log.info "### created database #{config['db2']['database']}"
  end

  desc 'create database "db2_{AR_ENV}"'
  task create_db2: [:connect_db2] do
    config = ActiveRecord::Base.configurations
    if config['db2']['adapter'] == 'postgresql'
      db = config['db2']['database']
      config['db2']['database'] = 'postgres'
      ActiveRecord::Base.establish_connection config['db2']
      config['db2']['database'] = db
      ActiveRecord::Base.connection.create_database config['db2']['database']
    end
    Log.info "### created database #{config['db2']['database']}"
  end

  # --------- drop database ---------------
  desc 'drop all table in database "db1_{AR_ENV}, db2_{AR_ENV}"'
  task drop: [:drop_db1, :drop_db2] do
  end

  desc 'drop all table in database "db1_{AR_ENV}'
  task drop_db1: [:connect_db1] do
    config = ActiveRecord::Base.configurations
    if config['db1']['adapter'] == 'sqlite3'
      FileUtils.rm config['db1']['database']
    else # config['db1']['adapter'] == 'postgresql'
      ActiveRecord::Base.establish_connection(config['db1'].merge('database' => 'postgres', 'schema_search_path' => 'public'))
      ActiveRecord::Base.connection.drop_database config['db1']['database']
    end
    Log.info "### dropped database #{config['db1']['database']}"
  end

  desc 'drop all table in database "db2_{AR_ENV}'
  task drop_db2: [:connect_db2] do
    config = ActiveRecord::Base.configurations
    if config['db2']['adapter'] == 'sqlite3'
      FileUtils.rm config['db2']['database']
    else # config['db2']['adapter'] == 'postgresql'
      ActiveRecord::Base.establish_connection(config['db2'].merge('database' => 'postgres', 'schema_search_path' => 'public'))
      ActiveRecord::Base.connection.drop_database config['db2']['database']
    end
    Log.info "### dropped database #{config['db2']['database']}"
  end

  # --------- reset db1, db2  ---------------
  desc 'Reset db1, db2 (drop, create, migrate, fixtures)'
  #task reset: [:drop, :create, :migrate, :fixtures] do
  #end
  task :reset do
    system 'rake dbs:drop'
    system 'rake dbs:create'
    system 'rake dbs:migrate'
    system 'rake dbs:fixtures'
    system 'rake dbs:show'
  end

  # --------- migrate db1, db2  ---------------
  desc 'Migrate the database through scripts in db/migrate, Target specific version with VERSION=x'
  task migrate: [:migrate_db1, :migrate_db2] do
  end

  task migrate_db1: [:connect_db1] do
    ActiveRecord::Migrator.migrate('db/migrate/db1', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
  end
  task migrate_db2: [:connect_db2] do
    ActiveRecord::Migrator.migrate('db/migrate/db2', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
  end

  # --------- load fixtures in test/fixture/* ---------------
  desc 'Load fixtures into "db1_#{AR_ENV}, db2_#{AR_ENV}",  Load specific fixtures using FIXTURES=x,y'
  task fixtures: [:fixtures_db1, :fixtures_db2] do
  end
  task fixtures_db1: [:connect_db1] do
    dir = File.join(File.dirname(__FILE__), 'test', 'fixtures', 'db1')
    dir = ENV['FIXTURES'].split(/,/) if ENV['FIXTURES']
    fixtures = Dir.glob(File.join(dir, '*.{yml, csv}'))
    fixtures.each do |fixture_file|
      ActiveRecord::FixtureSet.create_fixtures(File.dirname(fixture_file), File.basename(fixture_file, '.*'))
    end
  end
  task fixtures_db2: [:connect_db2] do
    dir = File.join(File.dirname(__FILE__), 'test', 'fixtures', 'db2')
    dir = ENV['FIXTURES'].split(/,/) if ENV['FIXTURES']
    fixtures = Dir.glob(File.join(dir, '*.{yml, csv}'))
    fixtures.each do |fixture_file|
      ActiveRecord::FixtureSet.create_fixtures(File.dirname(fixture_file), File.basename(fixture_file, '.*'))
    end
  end

  desc 'Show db1_#{AR_ENV}'
  task show: [:show_db1, :show_db2] do
  end
  task show_db1: [:connect_db1] do
    Hirb.enable
    puts
    puts '------- User -----------'
    opts = {} # {fields:  [:id, :name, :email]}
    puts Hirb::Helpers::AutoTable.render(User.all.sort, opts) if User.all
  end

  desc 'Show db2_#{AR_ENV}'
  task show_db2: [:connect_db2] do
    Hirb.enable
    puts
    puts '------- Info -----------'
    opts = {} # {fields:  [:id, :name, :address]}
    puts Hirb::Helpers::AutoTable.render(Info.all.sort, opts) if User.all
  end

  task connect_db1: [:environment] do
    config = ActiveRecord::Base.configurations["db1"]
    ActiveRecord::Base.establish_connection(config)
  end

  task connect_db2: [:environment] do
    config = ActiveRecord::Base.configurations["db2"]
    ActiveRecord::Base.establish_connection(config)
  end

  task :environment do
    db_config_path = File.join(File.dirname(File.expand_path(__FILE__)), 'config', 'database.yml')
    db_config = YAML.load(ERB.new(File.read(db_config_path)).result)
    env = get_env()
    Log.info "### using AR_ENV = '#{env}' "
    if db_config[env]['db1']['adapter'] == 'postgresql'
      if ENV['AR_USER'].blank? || ENV['AR_PASSWORD'].blank?
        puts " ----- export AR_USER=xxxx  export=AR_PASSORD=xxx で DB アクセスのユーザー、パウワードを設定してください。"
      end
    end
    ActiveRecord::Base.configurations = db_config[env]
    # ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))
  end

end # namespace :db
