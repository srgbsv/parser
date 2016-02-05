require 'base64'
require 'logger'
require 'typhoeus'
require 'nokogiri'
require 'pry'

$leaf_list = ["http://www.amazon.com/s?ie=UTF8&bbn=17227&page=1&rh=n%3A283155%2Cn%3A%211000%2Cn%3A27%2Cn%3A17227%2Cn%3A17413",
 "http://www.amazon.com/s?ie=UTF8&bbn=17411&page=1&rh=n%3A283155%2Cn%3A%211000%2Cn%3A27%2Cn%3A17227%2Cn%3A17411%2Cn%3A67559",
 "http://www.amazon.com/s?ie=UTF8&bbn=17411&page=1&rh=n%3A283155%2Cn%3A%211000%2Cn%3A27%2Cn%3A17227%2Cn%3A17411%2Cn%3A67558",
 "http://www.amazon.com/s?ie=UTF8&bbn=17411&page=1&rh=n%3A283155%2Cn%3A%211000%2Cn%3A27%2Cn%3A17227%2Cn%3A17411%2Cn%3A67557",
 "http://www.amazon.com/s?ie=UTF8&bbn=17409&page=1&rh=n%3A283155%2Cn%3A%211000%2Cn%3A27%2Cn%3A17227%2Cn%3A17409%2Cn%3A67556",
 "http://www.amazon.com/s?ie=UTF8&bbn=17409&page=1&rh=n%3A283155%2Cn%3A%211000%2Cn%3A27%2Cn%3A17227%2Cn%3A17409%2Cn%3A67555"] 

$author_list = ["http://www.amazon.com/Kevin-Revolinski/e/B001JSB10U/ref=sr_ntt_srch_lnk_1?qid=1454626632&sr=1-1",
 "http://www.amazon.com/Nichole-Fromm/e/B00WTICSK6/ref=sr_ntt_srch_lnk_2?qid=1454626632&sr=1-2",
 "http://www.amazon.com/JonMichael-Rasmus/e/B00WTIDC0G/ref=sr_ntt_srch_lnk_2?qid=1454626632&sr=1-2",
 "http://www.amazon.com/Kevin-Revolinski/e/B001JSB10U/ref=sr_ntt_srch_lnk_3?qid=1454626632&sr=1-3",
 "http://www.amazon.com/Justin-Doherty/e/B001KD55SI/ref=sr_ntt_srch_lnk_4?qid=1454626632&sr=1-4",
 "http://www.amazon.com/Craig-Mathews/e/B001K7YNBE/ref=sr_ntt_srch_lnk_6?qid=1454626632&sr=1-6",
 "http://www.amazon.com/Johnny-Molloy/e/B000APK5XW/ref=sr_ntt_srch_lnk_7?qid=1454626632&sr=1-7",
 "http://www.amazon.com/Mary-Carpenter/e/B001HP5IGI/ref=sr_ntt_srch_lnk_12?qid=1454626632&sr=1-12",
 "http://www.amazon.com/Sam-Night/e/B00LLYLW56/ref=sr_ntt_srch_lnk_15?qid=1454626633&sr=1-15",
 "http://www.amazon.com/Violette-Verne/e/B00J6H739Y/ref=sr_ntt_srch_lnk_16?qid=1454626633&sr=1-16",
 "http://www.amazon.com/Gwen-Evans/e/B001JS445O/ref=sr_ntt_srch_lnk_18?qid=1454626633&sr=1-18",
 "http://www.amazon.com/Harriet-Brown/e/B001IXM9J8/ref=sr_ntt_srch_lnk_20?qid=1454626633&sr=1-20",
 "http://www.amazon.com/Jason-Smathers/e/B002Y4LTKU/ref=sr_ntt_srch_lnk_22?qid=1454626633&sr=1-22",
 "http://www.amazon.com/Younghusband-American-City-Notebooks/e/B00J3NI656/ref=sr_ntt_srch_lnk_26?qid=1454626634&sr=1-26",
 "http://www.amazon.com/Cheryl-Eichar-Jett/e/B002JVDR80/ref=sr_ntt_srch_lnk_27?qid=1454626634&sr=1-27",
 "http://www.amazon.com/Doug-Shidell-and-Dave-Milaeger/e/B00IQP6IYI/ref=sr_ntt_srch_lnk_28?qid=1454626634&sr=1-28",
 "http://www.amazon.com/Chris-Martell/e/B00IYANQR2/ref=sr_ntt_srch_lnk_31?qid=1454626634&sr=1-31",
 "http://www.amazon.com/Chris-Martell/e/B00IYANQR2/ref=sr_ntt_srch_lnk_39?qid=1454626635&sr=1-39",
 "http://www.amazon.com/James-T.-Hair/e/B00IRW4WRK/ref=sr_ntt_srch_lnk_42?qid=1454626635&sr=1-42",
 "http://www.amazon.com/Violette-Verne/e/B00J6H739Y/ref=sr_ntt_srch_lnk_47?qid=1454626635&sr=1-47",
 "http://www.amazon.com/Fran-Sharmen/e/B00MQG9GWO/ref=sr_ntt_srch_lnk_49?qid=1454626635&sr=1-49",
 "http://www.amazon.com/Sharon-Clyde/e/B00LW6TRGE/ref=sr_ntt_srch_lnk_50?qid=1454626635&sr=1-50",
 "http://www.amazon.com/Violette-Verne/e/B00J6H739Y/ref=sr_ntt_srch_lnk_51?qid=1454626635&sr=1-51",
 "http://www.amazon.com/Fran-Sharmen/e/B00MQG9GWO/ref=sr_ntt_srch_lnk_52?qid=1454626635&sr=1-52",
 "http://www.amazon.com/Gary-Hogsten/e/B001HPUYHQ/ref=sr_ntt_srch_lnk_57?qid=1454626635&sr=1-57",
 "http://www.amazon.com/Sharon-Clyde/e/B00LW6TRGE/ref=sr_ntt_srch_lnk_58?qid=1454626635&sr=1-58",
 "http://www.amazon.com/Sharon-Clyde/e/B00LW6TRGE/ref=sr_ntt_srch_lnk_59?qid=1454626635&sr=1-59",
 "http://www.amazon.com/Sharon-Clyde/e/B00LW6TRGE/ref=sr_ntt_srch_lnk_60?qid=1454626635&sr=1-60",
 "http://www.amazon.com/Doug-Gelbert/e/B001K8KF2Y/ref=sr_ntt_srch_lnk_63?qid=1454626636&sr=1-63",
 "http://www.amazon.com/Doug-Gelbert/e/B001K8KF2Y/ref=sr_ntt_srch_lnk_67?qid=1454626636&sr=1-67",
 "http://www.amazon.com/Robert-A.-Birmingham/e/B00IY66S6W/ref=sr_ntt_srch_lnk_70?qid=1454626636&sr=1-70",
 "http://www.amazon.com/Katherine-H.-Rankin/e/B00IY3EEEI/ref=sr_ntt_srch_lnk_70?qid=1454626636&sr=1-70",
 "http://www.amazon.com/Larry-A.-Sakar/e/B001KCNU8G/ref=sr_ntt_srch_lnk_4?qid=1454626638&sr=1-4" ]

class AmazonBookParser
    attr_accessor :new_base_url

    def initialize()
        @base_url = "http://www.amazon.com/s/ref=sr_ex_n_1?rh=n%3A283155&bbn=283155&sort=date-desc-rank&ie=UTF8&qid=1454596618&lo=none"
        @next_link = nil
        @logger = Logger.new(STDOUT)
        @cat_array = []
        @cat_link_list = []
        @cat_leaf_link_list = []
        @author_links = []
        @authors = []
        @domain = "http://www.amazon.com"
        @error = false
        @file = nil
    end

    def parse
#       parse_catalog() 
#        parse_book_pages()
#        parse_authors()
        pres = parse_author_link('http://www.amazon.com/Violette-Verne/e/B00J6H739Y/')
        binding.pry
    end

    def parse_catalog
        while !@error do
            if (@cat_link_list.length == 0) 
                @next_link = @base_url
            else
                @next_link = @cat_link_list.pop();
                if @cat_leaf_link_list.length>5

                end
            end
            parse_catalog_link(@next_link)
        end
    end

    def parse_catalog_link(link)
        @logger.info "Parsing catalog link: #{link}"
        request = Typhoeus::Request.new(link, cookiefile: "amazon_cookie", cookiejar: "amazon_cookie", followlocation: true)
        request_body = nil
        request.on_complete do |response|
            if response.success?
                request_body = response.body
            elsif response.timed_out?
                # aw hell no
                @logger.info("got a time out")
            elsif response.code == 0
                # Could not get an http response, something's wrong.
                @logger.info(response.return_message)
            else
                # Received a non-successful http response.
                @logger.info("HTTP request failed: " + response.code.to_s)
            end
        end
        request.run();
        html_doc = Nokogiri::HTML(request_body)
        is_not_leaf = false
        ul_book_cat_li = html_doc.css('.categoryRefinementsSection ul li a');
        ul_book_cat_li.each do |book_li|
            children = book_li.first_element_child()
            if children['class'] == 'refinementLink'
                @cat_array.push({'name' => children.text, 'href' => @domain+book_li['href']})
                @cat_link_list.push(@domain+book_li['href'])
                is_not_leaf = true
            end
        end
        if !is_not_leaf
            @cat_leaf_link_list.push(link)
        end
    end

    def parse_book_pages()
        next_link = $leaf_list.pop();
        while !@error do
            next_link = parse_book_page_link(next_link)
            if !next_link
                next_link = $leaf_list.pop()
            end
            if (@author_links.length > 150)
                return
            end
        end
    end

    def parse_book_page_link(link)
        @logger.info "Parsing book link: #{link}"
        request = Typhoeus::Request.new(link, cookiefile: "amazon_cookie", cookiejar: "amazon_cookie", followlocation: true)
        request_body = nil
        request.on_complete do |response|
            if response.success?
                request_body = response.body
            elsif response.timed_out?
                # aw hell no
                @logger.info("got a time out")
            elsif response.code == 0
                # Could not get an
                @logger.info(response.return_message)
            else
                # Received a non-successful http response.
                @logger.info("HTTP request failed: " + response.code.to_s)
            end
        end
        request.run();
        html_doc = Nokogiri::HTML(request_body)
        page_next_link = nil;
        page_a = html_doc.css('#pagnNextLink');
        if page_a.length>0
            page_next_link = @domain+page_a[0]['href']
        end

        author_links = html_doc.css('span.a-size-small.a-color-secondary a.a-link-normal.a-text-normal')

        author_links.each do |author|
            @author_links.push(clear_author_link(@domain+author['href']))
        end
        
        return page_next_link
    end

    def parse_authors
        author_list_uniq = @author_links.uniq
        file = File.open('authors.txt', 'w')        
        author_list_uniq.each do |author_page_link|
            author_row = parse_author_link(author_page_link)
            @authors.push(author_row)
            file.puts('url => "' + author_row['link'] +'"; name => "'+author_row['name']+'"; photo => "'+author_row['photo']+'"; bio => "'+author_row['bio']+'";')
        end
        file.close
    end

    def clear_author_link(link)
        match = /^(http\:\/\/www.amazon.com\/[^\/]+\/e\/[A-Z0-9]{10}\/).*$/.match(link)
        return match[1]
    end

    def parse_author_link(link)
        @logger.info "Parsing author link: #{link}"
        request = Typhoeus::Request.new(link, cookiefile: "amazon_cookie.txt", cookiejar: "amazon_cookie.txt", followlocation: true)
        request_body = nil
        request.on_complete do |response|
            if response.success?
                request_body = response.body
            elsif response.timed_out?
                # aw hell no
                @logger.info("got a time out")
            elsif response.code == 0
                # Could not get an http response, something's wrong.
                @logger.info(response.return_message)
            else
                # Received a non-successful http response.
                @logger.info("HTTP request failed: " + response.code.to_s)
            end
        end
        request.run();
        html_doc = Nokogiri::HTML(request_body)
        author_name = html_doc.css('#ap-author-name h1');
        if author_name.length>0
            author_name = author_name[0].text
        end
        photo = html_doc.css('.ap-author-image');
        if photo.length>0
            photo = photo[0]['src']
        end
        bio = html_doc.css('#ap-bio .a-expander-content span')
        if bio.length>0
            bio = bio[0].text
        end
        page_a = html_doc.css('.a-link-child');        
        if page_a.length>0
            page_next_link = @domain+page_a[0]['href']
        end
        return {
            'link' => link,
            'name' => author_name,
            'photo' => photo,
            'bio' => bio,
            'books' => parse_author_books(page_next_link, author_name)
        }
    end

    def parse_author_books(link, author_name)
        page_next_link = link
        author_book_list = []
        while page_next_link do
            page_next_link = parse_author_book_link(page_next_link, author_book_list, author_name)
        end
        return author_book_list
    end

    def parse_author_book_link(link, author_book_list, author_name)
        @logger.info "Parsing author books list: #{link}"
        request = Typhoeus::Request.new(link, cookiefile: "amazon_cookie.txt", cookiejar: "amazon_cookie.txt", followlocation: true)
        request_body = nil
        request.on_complete do |response|
            if response.success?
                request_body = response.body
            elsif response.timed_out?
                # aw hell no
                @logger.info("got a time out")
            elsif response.code == 0
                # Could not get an http response, something's wrong.
                @logger.info(response.return_message)
            else
                # Received a non-successful http response.
                @logger.info("HTTP request failed: " + response.code.to_s)
            end
        end
        request.run();
        html_doc = Nokogiri::HTML(request_body)
        page_next_link = nil;
        page_a = html_doc.css('#pagnNextLink');
        if page_a.length>0
            page_next_link = @domain+page_a[0]['href']
        end
        book_list_containers = html_doc.css('#atfResults .s-result-item');
        book_list_containers.each do |row|
            book_title_link = row.css('a.a-link-normal.s-access-detail-page.a-text-normal')
            coauthors = row.css('.a-spacing-small>.a-spacing-none>.a-size-small.a-color-secondary')
            coauthors_list=[]
            coauthors.each do |co_row|
                if co_row.text == 'by '
                    next
                end
                coauthor = {}
                co_links = co_row.css('a')
                if co_links.length>0
                    coauthor['link'] = clear_author_link(@domain+co_links[0]['href'])
                    coauthor['name'] = co_links[0].text
                else 
                    coauthor['name'] = co_row.text
                end
                if (coauthor['name'].index(author_name))
                    next
                end
                coauthors_list.push(coauthor)
            end
            author_book_list.push({
                'title' => book_title_link[0]['title'],
                'link' => book_title_link[0]['href'],
                'coauthors' => coauthors_list
            })
        end
        return page_next_link
    end

    def base_url
        return new_base_url if new_base_url != nil

        "http://www.amazon.com/s/ref=sr_ex_n_1?rh=n%3A283155&bbn=283155&sort=date-desc-rank&ie=UTF8&qid=1454596618&lo=none"
    end
end

parser = AmazonBookParser.new()
parser.parse
