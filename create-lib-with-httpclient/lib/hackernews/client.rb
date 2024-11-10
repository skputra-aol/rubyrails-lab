module Hackernews
  class Client
    def initialize
      @host = 'yc-hacker-news-official.p.rapidapi.com'
      @key = '0b8bc9030dmsh879c0ddf03346bcp103f5ajsn345974903803'
    end

    ## detail info ["title,""time","score"] dari "id" topstories()
    def item_stories(id)
      get("item/#{id}")
    end

    def topstory(id)
      item_stories(id)
    end

    def topstoriesall()
      stories = get('topstories')
      #stories.map! do |story|
      #    item_stories(story)
      #end
    end

    ## only return 1  array yaitu ["id"]
    def topstories(start = 0, per_page = 10)

      stories = get('topstories')[start...start + per_page]
       ## array [currentpage to (currentpage+per_page)]

      stories.map! do |story|
          item_stories(story)
      end
      stories
    end

    private

    def get(path)
      response = Excon.get('https://' + @host + '/' + path + '.json?print=pretty',headers: {'x-rapidapi-host' => @host, 'x-rapidapi-key' => @key,})

      return false if response.status != 200

      JSON.parse(response.body)
    end
  end
end
