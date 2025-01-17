require 'date'

module PairingMatrix
  class CommitReader
    def initialize(config)
        @config = config
    end

    def authors_with_commits(days)
        date = (Date.today - days).to_s
        authors = authors(date)
        author_groups = authors.group_by { |n| titleize(n)}
        author_groups.map do |k, v|
            pair = k.split(',')
            pair.unshift('') if pair.size == 1
            [pair, v.size].flatten
        end
    end

    protected
    def read(since)
        #to be implemented by child commit reader
    end

    private
    def authors(since)
        commits = if @config.absent? then [] else read(since) end
        commits.map do |commit|
          if commit.include? "|" then
            commit.split("|").reject { |c| c.empty? }[1].split(",").map { |name| name.gsub(' ', '') }.sort.join(',')
          end
        end.compact.reject(&:empty?)
    end

    def titleize(name)
        name.gsub(/\w+/) do |word|
            word.capitalize
        end
    end
  end
end