module ApplicationHelper

  def user_label(user)
    if(user)
      label = user.name.blank? ? user.label : user.name
      label = user.email_fragment unless label
    end
    label ? label : "Anonymous"
  end
  
  # This helper is a stand-in until one of these problems is fixed:
  # 
  # 1. fontcustom supports ligatures
  # 2. webkit supports CSS transitions on :before elements
  def icon_for(word)
    return "?" unless icon_words.include?(word.to_s)
    "&#xf#{100 + icon_words.index(word.to_s)}".html_safe
  end

  def icon_words
    %w(fukuoka github kochi miyagi moon osaka sun twitter)
  end
  
  def japan_prefectures
    # %w(fukuoka kochi miyagi osaka)
    %w(fukuoka)
  end
  
  def markdown(text, options)
    MarkdownRenderer.to_html(text, localize: true).html_safe
  end
  
end