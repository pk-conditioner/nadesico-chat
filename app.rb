require 'sinatra'
require 'csv'
require 'json'

# 設定部分----------------------
DB_FILE = 'ruri_data.csv'

begin
    RESPONSES = CSV.read(DB_FILE, headers: true, encoding: 'UTF-8').map(&:to_h)
    puts "システム起動: ホシノ・ルリの会話パターンを読み込みました。"
rescue => e
    puts "エラー: CSVファイルが見つかりません..."
    exit
end

def ruri_response(input_text)
    # 入力がない場合無言を返す
    if(input_text.nil? || input_text.strip.empty?)
        return "_(無言 )"
    end
    match = RESPONSES.find do |row|
        row['keyword'] && input_text.include?(row['keyword'])
    end

    if match
        return match['response']
    else
        fallback_responses = [
        "ちょっとよくわかりません",
        "私は、少女ですから大人の話はわかりません",
        "__(ジト目)",
        "バカばっか"
    ]
        return fallback_responses.sample
    end
end
# 設定部分終わり----------------------

#チャットAPI--------------------------
get '/' do
    content_type :text
    "System Online: Ruri Char Server is running"
end

get '/chat' do
    user_message = params[:message]
    
    # ルリの思考回路を通す
    reply_text = ruri_response(user_message)
    
    # JSON形式で返す
    content_type :json
    { reply: reply_text }.to_json
end
