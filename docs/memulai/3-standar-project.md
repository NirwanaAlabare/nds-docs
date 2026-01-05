---
title: "Standar Project"
---

Standar untuk project ini cukup simple. Hanya fokus pada cycle Model->Controller->View dan hasil.

### Standar Penggunaan Laravel

Standar untuk project ini berfokus pada 3 hal berikut, yaitu **Model**, **View**, dan **Controller** yang memiliki perannya masing-masing.

#### 1. Model

Digunakan untuk mengkonfigurasi perilaku table, koneksi yang digunakan, relasi antar table, dan sebagainya. Contoh sederhana sebuah Model di NDS:

```php title="app\Models\SignalBit\MasterPlan.php"
namespace App\Models\SignalBit;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MasterPlan extends Model
{
    use HasFactory;

    protected $connection = 'mysql_sb';

    protected $table = 'master_plan';

    protected $guarded = [];

    public $timestamps = false;

    public function userPassword()
    {
        return $this->belongsTo(UserLine::class, 'sewing_line', 'username');
    }

    public function actCosting()
    {
        return $this->belongsTo(ActCosting::class, 'id_ws', 'id');
    }

    // QC Endline
    public function rfts()
    {
        return $this->hasMany(Rft::class, 'master_plan_id', 'id');
    }

    public function defects()
    {
        return $this->hasMany(Defect::class, 'master_plan_id', 'id');
    }

    public function rejects()
    {
        return $this->hasMany(Reject::class, 'master_plan_id', 'id');
    }

    public function reworks()
    {
        return $this->hasMany(Rework::class, 'master_plan_id', 'id');
    }

    // QC Packing
    public function rftsPacking()
    {
        return $this->hasMany(OutputPacking::class, 'master_plan_id', 'id');
    }
}
```

Connection diatur dalam <code>config/database.php</code> :

```php title="config/database.php"
'connections' => [

    'sqlite' => [
        'driver' => 'sqlite',
        'url' => env('DATABASE_URL'),
        'database' => env('DB_DATABASE', database_path('database.sqlite')),
        'prefix' => '',
        'foreign_key_constraints' => env('DB_FOREIGN_KEYS', true),
    ],

    'mysql' => [
        'driver' => 'mysql',
        'url' => env('DATABASE_URL'),
        'host' => env('DB_HOST', '127.0.0.1'),
        'port' => env('DB_PORT', '3306'),
        'database' => env('DB_DATABASE', 'forge'),
        'username' => env('DB_USERNAME', 'forge'),
        'password' => env('DB_PASSWORD', ''),
        'unix_socket' => env('DB_SOCKET', ''),
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'prefix' => '',
        'prefix_indexes' => true,
        'strict' => false,
        'engine' => null,
        'options' => extension_loaded('pdo_mysql') ? array_filter([
            PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
        ]) : [],
    ],

    'mysql_sb' => [
        'driver' => 'mysql',
        'url' => env('DATABASE_URL'),
        'host' => env('DB_HOST_SB', '127.0.0.1'),
        'port' => env('DB_PORT_SB', '3306'),
        'database' => env('DB_DATABASE_SB', 'forge'),
        'username' => env('DB_USERNAME_SB', 'forge'),
        'password' => env('DB_PASSWORD_SB', ''),
        'unix_socket' => env('DB_SOCKET_SB', ''),
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'prefix' => '',
        'prefix_indexes' => true,
        'strict' => false,
        'engine' => null,
        'options' => extension_loaded('pdo_mysql') ? array_filter([
            PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
        ]) : [],
    ],

    'mysql_dsb' => [
        'driver' => 'mysql',
        'url' => env('DATABASE_URL'),
        'host' => env('DB_HOST_DSB', '10.10.5.12'),
        'port' => env('DB_PORT_DSB', '3306'),
        'database' => env('DB_DATABASE_DSB', 'forge'),
        'username' => env('DB_USERNAME_DSB', 'forge'),
        'password' => env('DB_PASSWORD_DSB', ''),
        'unix_socket' => env('DB_SOCKET_DSB', ''),
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'prefix' => '',
        'prefix_indexes' => true,
        'strict' => false,
        'engine' => null,
        'options' => extension_loaded('pdo_mysql') ? array_filter([
            PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
        ]) : [],
    ],

    'mysql_hris' => [
        'driver' => 'mysql',
        'url' => env('DATABASE_URL'),
        'host' => env('DB_HOST_HRIS', '127.0.0.1'),
        'port' => env('DB_PORT_HRIS', '3306'),
        'database' => env('DB_DATABASE_HRIS', 'forge'),
        'username' => env('DB_USERNAME_HRIS', 'forge'),
        'password' => env('DB_PASSWORD_HRIS', ''),
        'unix_socket' => env('DB_SOCKET_HRIS', ''),
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'prefix' => '',
        'prefix_indexes' => true,
        'strict' => false,
        'engine' => null,
        'options' => extension_loaded('pdo_mysql') ? array_filter([
            PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
        ]) : [],
    ],

    'pgsql' => [
        'driver' => 'mysql',
        'url' => env('DATABASE_URL'),
        'host' => env('DB_HOST_PG', '127.0.0.1'),
        'port' => env('DB_PORT_PG', '5432'),
        'database' => env('DB_DATABASE_PG', 'forge'),
        'username' => env('DB_USERNAME_PG', 'forge'),
        'password' => env('DB_PASSWORD_PG', ''),
        'charset' => 'utf8',
        'prefix' => '',
        'prefix_indexes' => true,
        'schema' => 'public',
        'sslmode' => 'prefer',
    ],

    'sqlsrv' => [
        'driver' => 'sqlsrv',
        'url' => env('DATABASE_URL'),
        'host' => env('DB_HOST', 'localhost'),
        'port' => env('DB_PORT', '1433'),
        'database' => env('DB_DATABASE', 'forge'),
        'username' => env('DB_USERNAME', 'forge'),
        'password' => env('DB_PASSWORD', ''),
        'charset' => 'utf8',
        'prefix' => '',
        'prefix_indexes' => true,
    ],

],
```

#### 2. View

Digunakan sebagai front-end dengan menggunakan **layout** seperti berikut :

```
{{-- Page Configurations --}}
    @if (!isset($page))
        @php
            $page = '';
        @endphp
    @endif

    @if (!isset($subPage))
        @php
            $subPage = '';
        @endphp
    @endif

    @if (!isset($subPageGroup))
        @php
            $subPageGroup = '';
        @endphp
    @endif

    @if (!isset($head))
        @php
            $head = '';
        @endphp
    @endif

    @if (!isset($navbar))
        @php
            $navbar = true;
        @endphp
    @endif

    @if (!isset($containerFluid))
        @php
            $containerFluid = false;
        @endphp
    @endif

    @if (!isset($footer))
        @php
            $footer = true;
        @endphp
    @endif
{{-- End of Page Configurations --}}

<!DOCTYPE html>

<html lang="en">

<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1" name="viewport"/>
    <meta content="ie=edge" http-equiv="X-UA-Compatible"/>
    <meta content="{{ csrf_token() }}" name="csrf-token">
    <link href="{{ asset('dist/img/tabicon.png') }}" rel="icon" sizes="16x16" type="image/png"/>
    <title>{{ preg_match("/generate/i", strtolower(Route::current()->;getName())) &lt; 1 ? (ucwords(preg_replace("/-|_/", " ", Route::current()->;getName())) ? ucwords(preg_replace("/-|_/", " ", Route::current()->;getName())) : "NDS") : "NDS" }}</title>

    @include('layouts.link')

    @yield('custom-link')
</meta></head>

<body class="hold-transition layout-top-nav">
    <div class="wrapper">
        <!-- Navbar -->
        @if ($navbar)
            @include('layouts.navbar', ['page' => $page, 'subPage' => $subPage, 'subPageGroup' => $subPageGroup, 'routeName' => Route::current()->;getName()])
        @endif

        <!-- Offcanvas -->
        @include('layouts.offcanvas')

        <!-- Loading -->
        <div class="loading-container-fullscreen d-none" id="loading">
            <div class="loading-container">
                <div class="loading"></div>
            </div>
        </div>

        <!-- Loading with Background -->
        <div class="loading-container-fullscreen-background d-none" id="loading-bg">
            <div class="loading-container">
                <div class="loading"></div>
            </div>
        </div>

        <!-- Content Wrapper -->
        <div class="content-wrapper pt-3">
            <!-- Header -->
            @if (isset($title))
                <div class="content-header">
                    <div class="container">
                        <div class="row mb-2">
                            <div class="col-sm-6">
                                <h1 class="m-0">{{ ucfirst($title) }}</h1>
                            </div>
                        </div>
                    </div>
                </div>
            @endif

            <!-- Main content -->
            <div class="content">
                <div "container"="" :="" class="{{ $containerFluid ?" container-fluid"="" }}"="">
                    @yield('content')
                </div>
            </div>
        </div>

        <!-- Footer -->
        @if ($footer)
            <footer class="main-footer">
                <strong>
                    <a class="text-dark" href="https://nirwanagroup.co.id/en/service/nirwana-alabare-santosa/" target="_blank">
                        Nirwana Digital Solution
                    </a> © {{ date('Y') }}
                </strong>
            </footer>
        @endif
    </div>

    @include('layouts.script')

    @stack('scripts')
</body>

</html>
```

Berikut contoh **penggunaan layout**nya :

```
@extends('layouts.index')

@section('custom-link')
    <!-- Your Custom Style for styling your front-end -->

    <!-- DataTables -->
    <link href="{{ asset('plugins/datatables-bs4/css/dataTables.bootstrap4.min.css') }}" rel="stylesheet"/>
    <link href="{{ asset('plugins/datatables-responsive/css/responsive.bootstrap4.min.css') }}" rel="stylesheet"/>
    <link href="{{ asset('plugins/datatables-buttons/css/buttons.bootstrap4.min.css') }}" rel="stylesheet"/>
@endsection

@section('content')
    <!-- Your Contents -->
@endsection

@section('custom-script')
    <!-- Your Custom Javascript for front-end logics -->

    <!-- DataTables  & Plugins -->
    <script src="{{ asset('plugins/datatables/jquery.dataTables.min.js') }}"></script>
    <script src="{{ asset('plugins/datatables-bs4/js/dataTables.bootstrap4.min.js') }}"></script>
    <script src="{{ asset('plugins/datatables-responsive/js/dataTables.responsive.min.js') }}"></script>
    <script src="{{ asset('plugins/datatables-responsive/js/responsive.bootstrap4.min.js') }}"></script>
@endsection
```

Untuk menaruh styling tambahan bisa di <code>@section("custom-link")</code>, dan script tambahan di <code>@section("script")</code>. Konten utama disimpan di <code>@section("content")</code>. Dan untuk mengirimkan request ke back-end menggunakan <b>JQuery ajax</b> diletakkan di <code>@section("custom-script")</code>

#### 3. Controller

Controller digunakan sebagai back-end. Tempat untuk business logic. Bisa juga menggunakan service untuk fungsi yang digunakan berulang-kali dibanyak tempat.

Contoh basic **Controller** :

```php title='app\Http\Controllers...'
namespace App\Http\Controllers;

use App\Models\ExampleModel;
use Illuminate\Http\Request;

class Example extends Controller
{
    /**
    * Display a listing of the resource.
    *
    * @return \Illuminate\Http\Response
    */
    public function index()
    {
        //
    }

    /**
    * Show the form for creating a new resource.
    *
    * @return \Illuminate\Http\Response
    */
    public function create()
    {
        //
    }

    /**
    * Store a newly created resource in storage.
    *
    * @param  \Illuminate\Http\Request  $request
    * @return \Illuminate\Http\Response
    */
    public function store(Request $request)
    {
        //
    }

    /**
    * Display the specified resource.
    *
    * @param  \App\Models\ExampleModel  $exampleModel
    * @return \Illuminate\Http\Response
    */
    public function show(ExampleModel $exampleModel)
    {
        //
    }

    /**
    * Show the form for editing the specified resource.
    *
    * @param  \App\Models\ExampleModel  $exampleModel
    * @return \Illuminate\Http\Response
    */
    public function edit(ExampleModel $exampleModel)
    {
        //
    }

    /**
    * Update the specified resource in storage.
    *
    * @param  \Illuminate\Http\Request  $request
    * @param  \App\Models\ExampleModel  $exampleModel
    * @return \Illuminate\Http\Response
    */
    public function update(Request $request, ExampleModel $exampleModel)
    {
        //
    }

    /**
    * Remove the specified resource from storage.
    *
    * @param  \App\Models\ExampleModel  $exampleModel
    * @return \Illuminate\Http\Response
    */
    public function destroy(ExampleModel $exampleModel)
    {
        //
    }
}
```

Jika request-nya menggunakan ajax, biasanya Controller akan mengembalikan **array** dengan format seperti berikut :

```php
return array(
    "status" =>; 200, // Status Code
    "message" =>; "Success", // Your message here
    "additional" =>; [],
);
```

Dan untuk **Datatables** :

```php
use Yajra\DataTables\Facades\DataTables;

...

return DataTables::eloquent($markersQuery)->toJson();

<!-- OR -->

return DataTables::of($markersQuery)->toJson();
```
