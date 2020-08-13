<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ 'Hospital Helper' }}</title>

    <!-- Scripts -->
{{--    <script src="{{ asset('js/app.js') }}" defer></script>--}}

    <!-- Fonts -->
    <link rel="dns-prefetch" href="//fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css?family=Nunito" rel="stylesheet">

    <!-- Styles -->
{{--    <link href="{{ asset('css/app.css') }}" rel="stylesheet">--}}
    <link rel="stylesheet" href="{{asset('css/bootstrap.min.css')}}">
{{--    <link rel="stylesheet" href="{{asset('css/font-awesome.min.css')}}">--}}
{{--    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">--}}
@yield('style')
</head>
<body >
    <div id="app">
        @include('partials.nav_bar')
        <main class="py-4">
            @yield('content')
        </main>
    </div>

    <script src="{{asset('js/jquery.min.js')}}"></script>
    <script src=""{{asset('js/popper-js-1.6.1.min.js')}}></script>
    <script src={{asset('js/bootstrap.min.js')}}></script>
    <script src={{asset('js/bootstrap3.min.js')}}></script>
    <script src="{{asset('js/editable_table.js')}}"></script>
    <script src="{{asset('js/axios.min.js')}}"></script>
    {{--    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>--}}
    {{--    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>--}}
    {{--    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>--}}
    @yield('script')
</body>
</html>
<style>
    body{
        {{--background-image: url({{asset('images/bg.jpg')}});--}}
        background-repeat: no-repeat;
        background-size: 100% 100%;
    }
</style>
