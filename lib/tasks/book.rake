require 'pdf-reader'
require 'tiktoken_ruby'
require_relative '../../app/api_clients/openai_client'

namespace :book do
    desc "Extracts pages text from a book into a CSV file."
    task :extract_pages, [:file_name] => :environment do |t, args|
        file_name = args[:file_name].blank? ? "book.pdf" : args[:file_name]
        input_file_path = Rails.root.join("static_files", file_name)
        output_file_path = Rails.root.join("static_files", "#{file_name}.pages.csv")
        
        book = PDF::Reader.new(input_file_path)
        page_count = book.page_count
        puts "Extracting #{page_count} pages from #{input_file_path}"
        encoding = Tiktoken.encoding_for_model(OpenaiClient::EMBEDDINGS_MODEL)
        CSV.open(output_file_path, "wb") do |csv|
            csv << ["title", "content", "tokens"]
            book.pages.each.with_index do |page, index| 
                page_number = index + 1
                content = extract_page_text(page)
                tokens = encoding.encode(content).length
                if tokens < OpenaiClient::MAX_EMBEDDING_TOKENS && content.length > 0
                    csv << ["Page #{page_number}", content, tokens]
                end
                print "."
            end
        end
        puts 
        puts "Pages extracted to #{output_file_path}"
    end

    desc "Generates embeddings for a book pages CSV file."
    task :generate_embeddings, [:file_name] => :environment do |t, args|
        file_name = args[:file_name].blank? ? "book.pdf" : args[:file_name]
        input_file_path = Rails.root.join("static_files", "#{file_name}.pages.csv")
        output_file_path = Rails.root.join("static_files", "#{file_name}.embeddings.csv")
        puts "Generating embeddings for #{input_file_path}"
        CSV.open(output_file_path, "wb") do |csv|
            csv << ["title"] + (0...OpenaiClient::MAX_EMBEDDING_DIMENSIONS).to_a
            CSV.foreach(input_file_path, headers: true) do |row|
                embedding = OpenaiClient.build.get_embedding(row["content"])
                csv << [row["title"]] + embedding
                print "."
            end
        end
        puts
        puts "Embeddings generated to #{output_file_path}"
    end
    
    desc "Extracts pages and generates embeddings for a book."
    task :process => [:extract_pages, :generate_embeddings]

end

def extract_page_text(page)
    page.text.split("\n").map(&:lstrip).reject(&:blank?).join(" ")
end