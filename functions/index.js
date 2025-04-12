// ==== index.js (Firebase Function) ====

const functions = require("firebase-functions");
const axios = require("axios");
const cors = require("cors")({ origin: true });

exports.linkedinToken = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const { code, redirectUri } = req.body;

      if (!code || !redirectUri) {
        return res.status(400).send({ error: "Missing code or redirectUri" });
      }

      const clientId = "782g9jewj0oqze";
      const clientSecret = "WPL_AP1.AHpkLMcTIGX0pTmJ.c2vJRQ==";

      // 1. Access Token holen
      const tokenResponse = await axios.post(
        "https://www.linkedin.com/oauth/v2/accessToken",
        new URLSearchParams({
          grant_type: "authorization_code",
          code,
          redirect_uri: redirectUri,
          client_id: clientId,
          client_secret: clientSecret,
        }).toString(),
        { headers: { "Content-Type": "application/x-www-form-urlencoded" } }
      );

      const accessToken = tokenResponse.data.access_token;

      // 2. Profildaten holen
      const profileRes = await axios.get(
        "https://api.linkedin.com/v2/me?projection=(id,localizedFirstName,localizedLastName,profilePicture(displayImage~:playableStreams))",
        { headers: { Authorization: `Bearer ${accessToken}` } }
      );

      // 3. E-Mail holen
      const emailRes = await axios.get(
        "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))",
        { headers: { Authorization: `Bearer ${accessToken}` } }
      );

      const profile = profileRes.data;
      const email = emailRes.data.elements[0]["handle~"].emailAddress;

      let imageUrl = null;
      try {
        const elements = profile.profilePicture["displayImage~"].elements;
        imageUrl = elements[elements.length - 1].identifiers[0].identifier;
      } catch (_) {}

      return res.status(200).send({
        firstName: profile.localizedFirstName,
        lastName: profile.localizedLastName,
        email,
        imageUrl,
      });
    } catch (error) {
      console.error("Fehler in Cloud Function:", error);
      return res.status(500).send({ error: error.message });
    }
  });
});