'use strict';
const http = require('http');
const env  = process.env

const server = http.createServer((req, res) => {
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    res.write(`
    <!DOCTYPE html>
        <html lang="ja">
            <body>
                <h1>これはソースリポジトリが更新されると自動的にデプロイされたアプリケーション</h1>
                <h1> ${env.appname} です。</h1>
            </body>
    </html>`);
    res.end();
});

const port = 80;
server.listen(port, () => {
    console.log('Listening on ' + port);
});
