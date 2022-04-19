class UserInfo {
  String? banner;
  String? description;
  String? icon;
  String? name;

  UserInfo({this.banner, this.description, this.icon, this.name});

  UserInfo.fromJson(Map<String, dynamic> json) {
    //banner = json['banner'];
    //description = json['description'];
    //icon = json['icon'];
    //name = json['name'];
    banner = json['subreddit']['banner_img'];
    banner = banner?.split("?")[0];
    description = json['subreddit']['public_description'];
    icon = json['subreddit']['icon_img'];
    icon = icon?.split("?")[0];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner'] = this.banner;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['name'] = this.name;
    return data;
  }
}

class PageData {
  String? author;
  String? id;
  String? permalink;
  String? selftext;
  String? title;
  String? type;
  String? url;

  PageData(
      {this.author,
      this.id,
      this.permalink,
      this.selftext,
      this.title,
      this.type,
      this.url});

  PageData.fromJsonO(Map<String, dynamic> json) {
    author = json['author'];
    id = json['id'];
    permalink = json['permalink'];
    selftext = json['selftext'];
    title = json['title'];
    type = json['type'];
    url = json['url'];
  }

  static PageData? fromJson(Map<String, dynamic> json) {
    if (json['data']['url'].toString().contains(".imgur")) return null;
    String id = json['kind'] + '_' + json['data']['id'];
    String type = "Unspecified";
    String url = json['data']['url'];

    if (json['data']['is_video'] == true) {
      type = "video";
      url = json['data']['media']['reddit_video']['fallback_url'];
    } else if (json['data']['url'].toString().contains(".jpg") ||
        json['data']['url'].toString().contains(".png") ||
        json['data']['url'].toString().contains(".gif")) {
      type = "image";
    }
    return PageData(
        author: json['data']['author'],
        id: id,
        permalink: json['data']['permalink'],
        selftext: json['data']['selftext'],
        title: json['data']['title'],
        type: type,
        url: url);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['id'] = this.id;
    data['permalink'] = this.permalink;
    data['selftext'] = this.selftext;
    data['title'] = this.title;
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}

class SettingOp {
  bool? over_18;
  bool? public_votes;
  bool? video_autoplay;
  bool? hide_ads;
  bool? show_presence;
  bool? show_promote;

  SettingOp({
    this.hide_ads,
    this.over_18,
    this.public_votes,
    this.video_autoplay,
    this.show_presence,
    this.show_promote,
  });

  SettingOp.fromJson(Map<String, dynamic> json) {
    over_18 = json['over_18'];
    public_votes = json['public_votes'];
    video_autoplay = json['video_autoplay'];
    hide_ads = json['hide_ads'];
    show_presence = json['show_presence'];
    show_promote = json['show_promote'];
  }
}

class CompletOption {
  String? acceptPms;
  bool? activityRelevantAds;
  bool? allowClicktracking;
  String? badCommentAutocollapse;
  bool? beta;
  bool? clickgadget;
  bool? collapseReadMessages;
  bool? compress;
  String? countryCode;
  bool? credditAutorenew;
  String? defaultCommentSort;
  bool? domainDetails;
  bool? emailChatRequest;
  bool? emailCommentReply;
  bool? emailCommunityDiscovery;
  bool? emailDigests;
  bool? emailMessages;
  bool? emailNewUserWelcome;
  bool? emailPostReply;
  bool? emailPrivateMessage;
  bool? emailUnsubscribeAll;
  bool? emailUpvoteComment;
  bool? emailUpvotePost;
  bool? emailUserNewFollower;
  bool? emailUsernameMention;
  bool? enableDefaultThemes;
  bool? enableFollowers;
  bool? feedRecommendationsEnabled;
  String? g;
  bool? hideAds;
  bool? hideDowns;
  bool? hideFromRobots;
  bool? hideUps;
  bool? highlightControversial;
  bool? highlightNewComments;
  bool? ignoreSuggestedSort;
  bool? inRedesignBeta;
  bool? labelNsfw;
  String? lang;
  bool? legacySearch;
  bool? liveOrangereds;
  bool? markMessagesRead;
  String? media;
  String? mediaPreview;
  int? minCommentScore;
  int? minLinkScore;
  bool? monitorMentions;
  bool? newwindow;
  bool? nightmode;
  bool? noProfanity;
  int? numComments;
  int? numsites;
  bool? organic;
  String? otherTheme;
  bool? over18;
  bool? privateFeeds;
  bool? profileOptOut;
  bool? publicVotes;
  bool? research;
  bool? searchIncludeOver18;
  bool? sendCrosspostMessages;
  bool? sendWelcomeMessages;
  bool? showFlair;
  bool? showGoldExpiration;
  bool? showLinkFlair;
  bool? showLocationBasedRecommendations;
  bool? showPresence;
  bool? showPromote;
  bool? showStylesheets;
  bool? showTrending;
  bool? showTwitter;
  bool? storeVisits;
  int? surveyLastSeenTime;
  String? themeSelector;
  bool? thirdPartyDataPersonalizedAds;
  bool? thirdPartyPersonalizedAds;
  bool? thirdPartySiteDataPersonalizedAds;
  bool? thirdPartySiteDataPersonalizedContent;
  bool? threadedMessages;
  bool? threadedModmail;
  bool? topKarmaSubreddits;
  bool? useGlobalDefaults;
  bool? videoAutoplay;

  CompletOption(
      {this.acceptPms,
      this.activityRelevantAds,
      this.allowClicktracking,
      this.badCommentAutocollapse,
      this.beta,
      this.clickgadget,
      this.collapseReadMessages,
      this.compress,
      this.countryCode,
      this.credditAutorenew,
      this.defaultCommentSort,
      this.domainDetails,
      this.emailChatRequest,
      this.emailCommentReply,
      this.emailCommunityDiscovery,
      this.emailDigests,
      this.emailMessages,
      this.emailNewUserWelcome,
      this.emailPostReply,
      this.emailPrivateMessage,
      this.emailUnsubscribeAll,
      this.emailUpvoteComment,
      this.emailUpvotePost,
      this.emailUserNewFollower,
      this.emailUsernameMention,
      this.enableDefaultThemes,
      this.enableFollowers,
      this.feedRecommendationsEnabled,
      this.g,
      this.hideAds,
      this.hideDowns,
      this.hideFromRobots,
      this.hideUps,
      this.highlightControversial,
      this.highlightNewComments,
      this.ignoreSuggestedSort,
      this.inRedesignBeta,
      this.labelNsfw,
      this.lang,
      this.legacySearch,
      this.liveOrangereds,
      this.markMessagesRead,
      this.media,
      this.mediaPreview,
      this.minCommentScore,
      this.minLinkScore,
      this.monitorMentions,
      this.newwindow,
      this.nightmode,
      this.noProfanity,
      this.numComments,
      this.numsites,
      this.organic,
      this.otherTheme,
      this.over18,
      this.privateFeeds,
      this.profileOptOut,
      this.publicVotes,
      this.research,
      this.searchIncludeOver18,
      this.sendCrosspostMessages,
      this.sendWelcomeMessages,
      this.showFlair,
      this.showGoldExpiration,
      this.showLinkFlair,
      this.showLocationBasedRecommendations,
      this.showPresence,
      this.showPromote,
      this.showStylesheets,
      this.showTrending,
      this.showTwitter,
      this.storeVisits,
      this.surveyLastSeenTime,
      this.themeSelector,
      this.thirdPartyDataPersonalizedAds,
      this.thirdPartyPersonalizedAds,
      this.thirdPartySiteDataPersonalizedAds,
      this.thirdPartySiteDataPersonalizedContent,
      this.threadedMessages,
      this.threadedModmail,
      this.topKarmaSubreddits,
      this.useGlobalDefaults,
      this.videoAutoplay});

  CompletOption.fromJson(Map<String, dynamic> json) {
    acceptPms = json['accept_pms'];
    activityRelevantAds = json['activity_relevant_ads'];
    allowClicktracking = json['allow_clicktracking'];
    badCommentAutocollapse = json['bad_comment_autocollapse'];
    beta = json['beta'];
    clickgadget = json['clickgadget'];
    collapseReadMessages = json['collapse_read_messages'];
    compress = json['compress'];
    countryCode = json['country_code'];
    credditAutorenew = json['creddit_autorenew'];
    defaultCommentSort = json['default_comment_sort'];
    domainDetails = json['domain_details'];
    emailChatRequest = json['email_chat_request'];
    emailCommentReply = json['email_comment_reply'];
    emailCommunityDiscovery = json['email_community_discovery'];
    emailDigests = json['email_digests'];
    emailMessages = json['email_messages'];
    emailNewUserWelcome = json['email_new_user_welcome'];
    emailPostReply = json['email_post_reply'];
    emailPrivateMessage = json['email_private_message'];
    emailUnsubscribeAll = json['email_unsubscribe_all'];
    emailUpvoteComment = json['email_upvote_comment'];
    emailUpvotePost = json['email_upvote_post'];
    emailUserNewFollower = json['email_user_new_follower'];
    emailUsernameMention = json['email_username_mention'];
    enableDefaultThemes = json['enable_default_themes'];
    enableFollowers = json['enable_followers'];
    feedRecommendationsEnabled = json['feed_recommendations_enabled'];
    g = json['g'];
    hideAds = json['hide_ads'];
    hideDowns = json['hide_downs'];
    hideFromRobots = json['hide_from_robots'];
    hideUps = json['hide_ups'];
    highlightControversial = json['highlight_controversial'];
    highlightNewComments = json['highlight_new_comments'];
    ignoreSuggestedSort = json['ignore_suggested_sort'];
    inRedesignBeta = json['in_redesign_beta'];
    labelNsfw = json['label_nsfw'];
    lang = json['lang'];
    legacySearch = json['legacy_search'];
    liveOrangereds = json['live_orangereds'];
    markMessagesRead = json['mark_messages_read'];
    media = json['media'];
    mediaPreview = json['media_preview'];
    minCommentScore = json['min_comment_score'];
    minLinkScore = json['min_link_score'];
    monitorMentions = json['monitor_mentions'];
    newwindow = json['newwindow'];
    nightmode = json['nightmode'];
    noProfanity = json['no_profanity'];
    numComments = json['num_comments'];
    numsites = json['numsites'];
    organic = json['organic'];
    otherTheme = json['other_theme'];
    over18 = json['over_18'];
    privateFeeds = json['private_feeds'];
    profileOptOut = json['profile_opt_out'];
    publicVotes = json['public_votes'];
    research = json['research'];
    searchIncludeOver18 = json['search_include_over_18'];
    sendCrosspostMessages = json['send_crosspost_messages'];
    sendWelcomeMessages = json['send_welcome_messages'];
    showFlair = json['show_flair'];
    showGoldExpiration = json['show_gold_expiration'];
    showLinkFlair = json['show_link_flair'];
    showLocationBasedRecommendations =
        json['show_location_based_recommendations'];
    showPresence = json['show_presence'];
    showPromote = json['show_promote'];
    showStylesheets = json['show_stylesheets'];
    showTrending = json['show_trending'];
    showTwitter = json['show_twitter'];
    storeVisits = json['store_visits'];
    surveyLastSeenTime = json['survey_last_seen_time'];
    themeSelector = json['theme_selector'];
    thirdPartyDataPersonalizedAds = json['third_party_data_personalized_ads'];
    thirdPartyPersonalizedAds = json['third_party_personalized_ads'];
    thirdPartySiteDataPersonalizedAds =
        json['third_party_site_data_personalized_ads'];
    thirdPartySiteDataPersonalizedContent =
        json['third_party_site_data_personalized_content'];
    threadedMessages = json['threaded_messages'];
    threadedModmail = json['threaded_modmail'];
    topKarmaSubreddits = json['top_karma_subreddits'];
    useGlobalDefaults = json['use_global_defaults'];
    videoAutoplay = json['video_autoplay'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['accept_pms'] = this.acceptPms.toString();
    data['activity_relevant_ads'] = this.activityRelevantAds.toString();
    data['allow_clicktracking'] = this.allowClicktracking.toString();
    data['bad_comment_autocollapse'] = this.badCommentAutocollapse.toString();
    data['beta'] = this.beta.toString();
    data['clickgadget'] = this.clickgadget.toString();
    data['collapse_read_messages'] = this.collapseReadMessages.toString();
    data['compress'] = this.compress.toString();
    data['country_code'] = this.countryCode.toString();
    data['creddit_autorenew'] = this.credditAutorenew.toString();
    data['default_comment_sort'] = this.defaultCommentSort.toString();
    data['domain_details'] = this.domainDetails.toString();
    data['email_chat_request'] = this.emailChatRequest.toString();
    data['email_comment_reply'] = this.emailCommentReply.toString();
    data['email_community_discovery'] = this.emailCommunityDiscovery.toString();
    data['email_digests'] = this.emailDigests.toString();
    data['email_messages'] = this.emailMessages.toString();
    data['email_new_user_welcome'] = this.emailNewUserWelcome.toString();
    data['email_post_reply'] = this.emailPostReply.toString();
    data['email_private_message'] = this.emailPrivateMessage.toString();
    data['email_unsubscribe_all'] = this.emailUnsubscribeAll.toString();
    data['email_upvote_comment'] = this.emailUpvoteComment.toString();
    data['email_upvote_post'] = this.emailUpvotePost.toString();
    data['email_user_new_follower'] = this.emailUserNewFollower.toString();
    data['email_username_mention'] = this.emailUsernameMention.toString();
    data['enable_default_themes'] = this.enableDefaultThemes.toString();
    data['enable_followers'] = this.enableFollowers.toString();
    data['feed_recommendations_enabled'] =
        this.feedRecommendationsEnabled.toString();
    data['g'] = this.g.toString();
    data['hide_ads'] = this.hideAds.toString();
    data['hide_downs'] = this.hideDowns.toString();
    data['hide_from_robots'] = this.hideFromRobots.toString();
    data['hide_ups'] = this.hideUps.toString();
    data['highlight_controversial'] = this.highlightControversial.toString();
    data['highlight_new_comments'] = this.highlightNewComments.toString();
    data['ignore_suggested_sort'] = this.ignoreSuggestedSort.toString();
    data['in_redesign_beta'] = this.inRedesignBeta.toString();
    data['label_nsfw'] = this.labelNsfw.toString();
    data['lang'] = this.lang.toString();
    data['legacy_search'] = this.legacySearch.toString();
    data['live_orangereds'] = this.liveOrangereds.toString();
    data['mark_messages_read'] = this.markMessagesRead.toString();
    data['media'] = this.media.toString();
    data['media_preview'] = this.mediaPreview.toString();
    data['min_comment_score'] = this.minCommentScore.toString();
    data['min_link_score'] = this.minLinkScore.toString();
    data['monitor_mentions'] = this.monitorMentions.toString();
    data['newwindow'] = this.newwindow.toString();
    data['nightmode'] = this.nightmode.toString();
    data['no_profanity'] = this.noProfanity.toString();
    data['num_comments'] = this.numComments.toString();
    data['numsites'] = this.numsites.toString();
    data['organic'] = this.organic.toString();
    data['other_theme'] = this.otherTheme.toString();
    data['over_18'] = this.over18.toString();
    data['private_feeds'] = this.privateFeeds.toString();
    data['profile_opt_out'] = this.profileOptOut.toString();
    data['public_votes'] = this.publicVotes.toString();
    data['research'] = this.research.toString();
    data['search_include_over_18'] = this.searchIncludeOver18.toString();
    data['send_crosspost_messages'] = this.sendCrosspostMessages.toString();
    data['send_welcome_messages'] = this.sendWelcomeMessages.toString();
    data['show_flair'] = this.showFlair.toString();
    data['show_gold_expiration'] = this.showGoldExpiration.toString();
    data['show_link_flair'] = this.showLinkFlair.toString();
    data['show_location_based_recommendations'].toString();
    this.showLocationBasedRecommendations.toString();
    data['show_presence'] = this.showPresence.toString();
    data['show_promote'] = this.showPromote.toString();
    data['show_stylesheets'] = this.showStylesheets.toString();
    data['show_trending'] = this.showTrending.toString();
    data['show_twitter'] = this.showTwitter.toString();
    data['store_visits'] = this.storeVisits.toString();
    data['survey_last_seen_time'] = this.surveyLastSeenTime.toString();
    data['theme_selector'] = this.themeSelector.toString();
    data['third_party_data_personalized_ads'] =
        this.thirdPartyDataPersonalizedAds.toString();
    data['third_party_personalized_ads'] =
        this.thirdPartyPersonalizedAds.toString();
    data['third_party_site_data_personalized_ads'] =
        this.thirdPartySiteDataPersonalizedAds.toString();
    data['third_party_site_data_personalized_content'] =
        this.thirdPartySiteDataPersonalizedContent.toString();
    data['threaded_messages'] = this.threadedMessages.toString();
    data['threaded_modmail'] = this.threadedModmail.toString();
    data['top_karma_subreddits'] = this.topKarmaSubreddits.toString();
    data['use_global_defaults'] = this.useGlobalDefaults.toString();
    data['video_autoplay'] = this.videoAutoplay.toString();
    return data;
  }
}
