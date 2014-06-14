class RandomWord
  WORDS = %w{tree sea car computer building board painting flower lamp glass coffee tea movie}
  def self.word
    WORDS.sample
  end
end
