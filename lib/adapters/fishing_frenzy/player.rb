class Adapters::FishingFrenzy::Player < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    # We want everything for now
    # Once all checks are done player -> @data.except(**excluded_data_keys)
    @data
  end

  def excluded_data_keys
    [
      :userPrivyId,
      :nextDayReward,
      :todayReward,
      :ethSpentFrenzyMode,
      :firstPlatform,
      :lastPlatform,
      :limitEasiestFishToCatch,
      :unlockedFish,
      :IPAddresses,
      :isCompleteTutorial,
      :isGuest,
      :isIntroVideoWatched,
      :isFreeSushiFirstTime,
      :startDateInCycle,
      :hasNewSocialQuest,
      :themeId,
      :eventId,
      :stepTutorial,
      :isNotificationTele,
      :totalSpentPhase1,
      :dailyPurchaseLimits,
      :deviceId,
      :isEnteredRefCode
    ]
  end
end
