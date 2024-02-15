String getWebsitIconFromUrl(String url, {int size = 32}) {
  final domainRegExp = RegExp(r'https?://(?:www\.)?([^\/]+)');
  final match = domainRegExp.firstMatch(url);

  if (match == null) {
    return "https://www.google.com/s2/favicons?sz=$size&domain_url=null";
  }

  //final domain = match.group(1);
  final domainWithHttp = url.substring(match.start, match.end);
  return "https://www.google.com/s2/favicons?sz=$size&domain_url=$domainWithHttp";
}
