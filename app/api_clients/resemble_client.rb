require "resemble"

class ResembleClient
    def self.build()
        new(ENV["RESEMBLE_API_KEY"], ENV["RESEMBLE_PROJECT_ID"], ENV["RESEMBLE_VOICE_ID"])
    end

    def initialize(resemble_api_key, project_id, voice_id)
        @resemble_api_key = resemble_api_key
        @project_id = project_id
        @voice_id = voice_id
    end

    def request_audio_file(text, callback_uri) 
        Resemble.api_key = @resemble_api_key
        Resemble::V2::Clip.create_async(
        @project_id,
        @voice_id,
        callback_uri,
        text,
        output_format: "mp3",
        title: nil,
        sample_rate: nil,
        precision: nil,
        include_timestamps: nil,
        is_public: nil,
        is_archived: nil
    )
    end
end