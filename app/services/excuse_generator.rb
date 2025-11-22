class ExcuseGenerator
  def initialize(task_name:, urgency: nil, mood: nil)
    @task_name = task_name
    @urgency = urgency
    @mood = mood
    @data = load_dictionary
  end

  def generate
    excuse1 = pick_random(@data["excuses"])
    excuse2 = pick_random(@data["excuses"])
    alt     = pick_random(@data["alternatives"])
    comment = pick_random(@data["comments"])

    build_text(excuse1, excuse2, alt, comment)
  end

  private

  # YAML辞書の読み込み（例外対策つき）
  def load_dictionary
    YAML.safe_load(
      File.read(Rails.root.join("config/excuses.yml")),
      permitted_classes: [Date, Time],
      aliases: true
    )
  rescue => e
    Rails.logger.error "YAML load error: #{e.message}"
    { "excuses" => [], "alternatives" => [], "comments" => [] }
  end

  # 安全にランダム抽選
  def pick_random(list)
    return "（データがありません）" if list.blank?
    list.sample
  end

  # 表示用の文章を組み立て
  def build_text(excuse1, excuse2, alt, comment)
    <<~TEXT
      【逃げ道のご提案】

      ■ 言い訳①
      #{excuse1}

      ■ 言い訳②
      #{excuse2}

      ■ 代替案
      #{alt}

      ■ 総評（AI風コメント）
      #{comment}

      ※タスク：#{@task_name}
      ※緊急度：#{@urgency.presence || "未指定"}
      ※気分：#{@mood.presence || "未入力"}
    TEXT
  end
end
