# frozen_string_literal: true

require 'httparty'

module Resemble
  include HTTParty
  headers 'Content-Type' => 'application/json'

  def self.api_key
    @token || nil
  end

  def self.api_key=(api_key)
    @token = api_key

    headers 'Authorization' => "Token token=#{@token}"
  end

  def self.base_url
    @base_url || 'https://app.resemble.ai/api/'
  end

  def self.base_url=(api_base_url)
    @base_url = api_base_url
  end

  def self.endpoint(version, endpoint)
    "#{Resemble.base_url}#{version}#{endpoint.start_with?('/') ? endpoint : "/#{endpoint}"}"
  end

  module V2
    module Project
      def self.all(page, page_size = nil)
        options = { query: { page: page } }
        options[:query][:page_size] = page_size unless page_size.nil?

        Resemble.get(Resemble.endpoint('v2', 'projects'), options).parsed_response
      end

      def self.create(name, description, is_public, is_collaborative, is_archived)
        options = {
          body: {
            name: name,
            description: description,
            is_public: is_public,
            is_collaborative: is_collaborative,
            is_archived: is_archived
          }.to_json
        }

        Resemble.post(Resemble.endpoint('v2', 'projects'), options).parsed_response
      end

      def self.update(uuid, name, description, is_public, is_collaborative, is_archived)
        options = {
          body: {
            name: name,
            description: description,
            is_public: is_public,
            is_collaborative: is_collaborative,
            is_archived: is_archived
          }.to_json
        }

        Resemble.put(Resemble.endpoint('v2', "projects/#{uuid}"), options).parsed_response
      end

      def self.get(uuid)
        Resemble.get(Resemble.endpoint('v2', "projects/#{uuid}")).parsed_response
      end

      def self.delete(uuid)
        Resemble.delete(Resemble.endpoint('v2', "projects/#{uuid}")).parsed_response
      end
    end

    module Voice
      def self.all(page, page_size = nil)
        options = { query: { page: page } }
        options[:query][:page_size] = page_size unless page_size.nil?

        Resemble.get(Resemble.endpoint('v2', 'voices'), options).parsed_response
      end

      def self.create(name, dataset_url = nil, callback_uri = nil)
        options = {
          body: {
            name: name,
            dataset_url: dataset_url,
            callback_uri: callback_uri
          }.compact.to_json
        }

        Resemble.post(Resemble.endpoint('v2', 'voices'), options).parsed_response
      end

      def self.update(uuid, name)
        options = {
          body: {
            name: name
          }.to_json
        }

        Resemble.put(Resemble.endpoint('v2', "voices/#{uuid}"), options).parsed_response
      end
      
      def self.build(uuid)
        Resemble.post(Resemble.endpoint('v2', "voices/#{uuid}/build")).parsed_response
      end

      def self.get(uuid)
        Resemble.get(Resemble.endpoint('v2', "voices/#{uuid}")).parsed_response
      end

      def self.delete(uuid)
        Resemble.delete(Resemble.endpoint('v2', "voices/#{uuid}")).parsed_response
      end
    end

    module Recording
      def self.all(voice_uuid, page, page_size = nil)
        options = { query: { page: page } }
        options[:query][:page_size] = page_size unless page_size.nil?

        Resemble.get(Resemble.endpoint('v2', "voices/#{voice_uuid}/recordings"), options).parsed_response
      end

      def self.create(voice_uuid, file, name, text, is_active, emotion)
        options = {
          multipart: true,
          body: {
            file: file,
            name: name,
            text: text,
            emotion: emotion,
            is_active: is_active
          }
        }

        Resemble.post(Resemble.endpoint('v2', "voices/#{voice_uuid}/recordings"), options).parsed_response
      end

      def self.update(voice_uuid, recording_uuid, name, text, is_active, emotion)
        options = {
          body: {
            name: name,
            text: text,
            emotion: emotion,
            is_active: is_active
          }.to_json
        }

        Resemble.put(Resemble.endpoint('v2', "voices/#{voice_uuid}/recordings/#{recording_uuid}"), options).parsed_response
      end

      def self.get(voice_uuid, recording_uuid)
        Resemble.get(Resemble.endpoint('v2', "voices/#{voice_uuid}/recordings/#{recording_uuid}")).parsed_response
      end

      def self.delete(voice_uuid, recording_uuid)
        Resemble.delete(Resemble.endpoint('v2', "voices/#{voice_uuid}/recordings/#{recording_uuid}")).parsed_response
      end
    end

    module Clip
      def self.all(project_uuid, page, page_size = nil)
        options = { query: { page: page } }
        options[:query][:page_size] = page_size unless page_size.nil?

        Resemble.get(Resemble.endpoint('v2', "projects/#{project_uuid}"), options).parsed_response
      end

      def self.create_sync(project_uuid, voice_uuid, body, title: nil, sample_rate: nil, output_format: nil, precision: nil, include_timestamps: nil, is_public: nil, is_archived: nil, raw: nil)
        options = {
          body: {
            title: title,
            body: body,
            voice_uuid: voice_uuid,
            is_public: is_public,
            is_archived: is_archived,
            sample_rate: sample_rate,
            output_format: output_format,
            precision: precision,
            include_timestamps: include_timestamps,
            raw: raw
          }.compact.to_json
        }

        Resemble.post(Resemble.endpoint('v2', "projects/#{project_uuid}/clips"), options).parsed_response
      end

      def self.create_async(project_uuid, voice_uuid, callback_uri, body, title: nil, sample_rate: nil, output_format: nil, precision: nil, include_timestamps: nil, is_public: nil, is_archived: nil)
        options = {
          body: {
            title: title,
            body: body,
            voice_uuid: voice_uuid,
            is_public: is_public,
            is_archived: is_archived,
            sample_rate: sample_rate,
            output_format: output_format,
            precision: precision,
            include_timestamps: include_timestamps,
            callback_uri: callback_uri
          }.compact.to_json
        }

        Resemble.post(Resemble.endpoint('v2', "projects/#{project_uuid}/clips"), options).parsed_response
      end

      def self.update_async(project_uuid, clip_uuid, voice_uuid, callback_uri, body, title: nil, sample_rate: nil, output_format: nil, precision: nil, include_timestamps: nil, is_public: nil, is_archived: nil)
        options = {
          body: {
            title: title,
            body: body,
            voice_uuid: voice_uuid,
            is_public: is_public,
            is_archived: is_archived,
            sample_rate: sample_rate,
            output_format: output_format,
            precision: precision,
            include_timestamps: include_timestamps,
            callback_uri: callback_uri
          }.compact.to_json
        }

        Resemble.put(Resemble.endpoint('v2', "projects/#{project_uuid}/clips/#{clip_uuid}"), options).parsed_response
      end

      def self.get(project_uuid, clip_uuid)
        Resemble.get(Resemble.endpoint('v2', "projects/#{project_uuid}/clips/#{clip_uuid}")).parsed_response
      end

      def self.delete(project_uuid, clip_uuid)
        Resemble.delete(Resemble.endpoint('v2', "projects/#{project_uuid}/clips/#{clip_uuid}")).parsed_response
      end
    end

  end # V2 end

end
