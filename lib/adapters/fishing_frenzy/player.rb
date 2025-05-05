class Adapters::FishingFrenzy::Player < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    @data.except(*excluded_data_keys)
  end

  def excluded_data_keys
    %i[
      userPrivyId
      nextDayReward
      todayReward
      ethSpentFrenzyMode
      firstPlatform
      lastPlatform
      limitEasiestFishToCatch
      unlockedFish
      IPAddresses
      isCompleteTutorial
      isGuest
      isIntroVideoWatched
      isFreeSushiFirstTime
      startDateInCycle
      hasNewSocialQuest
      themeId
      eventId
      stepTutorial
      isNotificationTele
      totalSpentPhase1
      dailyPurchaseLimits
      deviceId
      isEnteredRefCode
    ]
  end
end
