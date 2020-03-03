using System;
using System.Net.Http;
using System.Net.Http.Headers;

namespace Attendance
{
    public class WebInstance
    {
        internal HttpClient client;
        internal string base_url;

        public WebInstance(string url)
        {
            client = new HttpClient();

            // Add an Accept header for JSON format.
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            client.DefaultRequestHeaders.Add("Authorization", "Bearer " + MvcApplication.APIToken);

            if (!url.EndsWith("/"))
                url += "/";

            base_url = url;

            client.BaseAddress = new Uri(base_url);
        }

        public T Get<T>(string url, params string[] id)
        {
            var full_url = (url + "/" + (string.Join("/", id)).TrimEnd('/')).TrimEnd('/');

            using (var resp = client.GetAsync(full_url).Result)
            {
                if (resp.StatusCode == System.Net.HttpStatusCode.NotFound) return default(T);

                return resp.Content.ReadAsAsync<T>().Result;
            }
        }

        public T Post<T>(string url, object value)
        {
            using (var resp = client.PostAsJsonAsync(url, value).Result)
            {
                if (resp.StatusCode == System.Net.HttpStatusCode.NotFound) return default(T);

                return resp.Content.ReadAsAsync<T>().Result;
            }
        }

        public HttpResponseMessage Post(string url, object value)
        {
            return client.PostAsJsonAsync(url, value).Result;
        }

        public T PostFile<T>(string url, object value)
        {
            using (var resp = client.PostAsJsonAsync(url, value).Result)
            {
                if (resp.StatusCode == System.Net.HttpStatusCode.NotFound) return default(T);

                return resp.Content.ReadAsAsync<T>().Result;
            }
        }

        public T Put<T>(string url, string id, object value)
        {
            var full_url = url + "/" + id;
            using (var resp = client.PutAsJsonAsync(full_url, value).Result)
            {
                if (resp.StatusCode == System.Net.HttpStatusCode.NotFound) return default(T);

                return resp.Content.ReadAsAsync<T>().Result;
            }
        }

        public HttpResponseMessage Delete(string url, params string[] id)
        {
            var full_url = url + "/" + string.Join("/", id);
            return client.DeleteAsync(url + "/" + string.Join("/", id)).Result;
        }
    }
}