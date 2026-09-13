<?php
namespace App\Controller;
use Symfony\Component\HttpFoundation\Response;

class HelloController {
    public function index()
        {
            $result = <<< EOM
                <html>
                <head><title>Hello</title></head>
                <body>
                <h1>Hello Symfony!</h1>
                </body>
                </html>
EOM;
            return new Response($result);
        }
}
