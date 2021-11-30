package ru.lanit.at.api.models;

import com.google.gson.GsonBuilder;

public class RequestModel {

    private String method;
    private String body;
    private String path;
    private String url;
    private String filePath;
    private String fileName;

    public RequestModel(String method, String body, String path, String url, String filePath, String fileName) {
        this.method = method;
        this.body = body;
        this.path = path;
        this.url = url;
        this.filePath = filePath;
        this.fileName = fileName;
    }

    public String getMethod() {
        return method;
    }

    public String getBody() {
        return body;
    }

    public String getPath() {
        return path;
    }

    public String getUrl() {
        return url;
    }

    @Override
    public String toString() {
        return new GsonBuilder()
                .setPrettyPrinting()
                .create()
                .toJson(this);
    }

    public String getFileName() {
        return fileName;
    }

    public String getFilePath() {
        return filePath;
    }
}
