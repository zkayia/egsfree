
import 'dart:convert';
import 'dart:io';


extension GetUri on Uri {

	Future<String?> get([bool nullOnError=false]) async {
		final client = HttpClient();
		try {
			final request = await client.getUrl(this)
				..followRedirects = false
				..persistentConnection = false;
			final response = await request.close();
			return response.transform(utf8.decoder).join();
		} catch (err) {
			if (nullOnError) {
				return null;
			}
			stderr.writeln("Error: unable to fetch online data.");
			exit(1);
		} finally {
			client.close();
		}
	}
}
