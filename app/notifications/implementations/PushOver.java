package notifications.implementations;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Authenticator;
import java.net.HttpURLConnection;
import java.net.PasswordAuthentication;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Map;

import play.Logger;
import notifications.Notification;

public class PushOver implements Notification {
	public static final String USER_TOKEN = "user", APPLICATION_TOKEN ="token" , DEVICES = "devices";
	private Map<String, String> settings;

	@Override
	public void sendNotification(String title, String content) throws IOException {
	
		String encodedTitle = URLEncoder.encode(title, "UTF-8");
		String encodedContent = URLEncoder.encode(content, "UTF-8");
		String encodedAppToken = URLEncoder.encode(settings.get(APPLICATION_TOKEN), "UTF-8");
		String encodedUserToken = URLEncoder.encode(settings.get(USER_TOKEN), "UTF-8");
		
		String url = "https://api.pushover.net/1/messages.json";
		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();

		// add reuqest header
		con.setRequestMethod("POST");
		con.setRequestProperty("User-Agent", "Mozilla/5.0");
		con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

		String urlParameters = "title="+encodedTitle+"&message="+encodedContent+"&"+APPLICATION_TOKEN+"="+encodedAppToken+"&"+USER_TOKEN+"="+encodedUserToken;

		// Send post request
		con.setDoOutput(true);
		DataOutputStream wr = new DataOutputStream(con.getOutputStream());
		wr.writeBytes(urlParameters);
		wr.flush();
		wr.close();

		int responseCode = con.getResponseCode();
		Logger.info("\nSending 'POST' request to URL : " + url);
		Logger.info("Post parameters : " + urlParameters);
		Logger.info("Response Code : " + responseCode);

		BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();

		// print result
		Logger.info(response.toString());
	}

	@Override
	public boolean setSettings(Map<String, String> settings) {
		this.settings = settings;
		return settings.containsKey(APPLICATION_TOKEN) && !settings.get(APPLICATION_TOKEN).trim().equalsIgnoreCase("") && settings.containsKey(USER_TOKEN) && !settings.get(USER_TOKEN).trim().equalsIgnoreCase("");
	}

}