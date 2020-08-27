module Util
  def Util.init_date_of_book(book)
    if not book["end"]
      book["end"] = Time.now.year
    end

    if not book["start"]
      book["start"] = book["end"]
    end

    if book["start"] == book["end"]
      book["date"] = book["start"].to_s
    else
      book["date"] = "#{book["start"]}-#{book["end"]}"
    end
  end

  def Util.cover_default(default, params)
    for key in default
      default[key] = params[key] unless params[key].nil?
    end
    default
  end
end
