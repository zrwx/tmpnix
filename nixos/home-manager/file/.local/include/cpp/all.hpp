#ifndef ALL_HPP
#define ALL_HPP

// #include <algorithm>
// #include <any>
// #include <array>
// #include <atomic>
// #include <barrier>
// #include <bit>
// #include <bitset>
// #include <cassert>
// #include <ccomplex>
// #include <cctype>
// #include <cerrno>
// #include <cfenv>
// #include <cfloat>
// #include <charconv>
// #include <chrono>
// #include <cinttypes>
// #include <ciso646>
// #include <climits>
// #include <clocale>
// #include <cmath>
// #include <codecvt>
// #include <compare>
// #include <complex>
// #include <concepts>
// #include <condition_variable>
// #include <coroutine>
// #include <csetjmp>
// #include <csignal>
// /* #include <cstdalign> */
// #include <cstdarg>
// #include <cstdbool>
// #include <cstddef>
// #include <cstdint>
// #include <cstdio>
// #include <cstdlib>
// #include <cstring>
// #include <ctgmath>
// #include <ctime>
// /* #include <cuchar> */
// #include <cwchar>
// #include <cwctype>
// #include <deque>
// #include <exception>
// /* #include <expected> */
// #include <filesystem>
// #include <forward_list>
// #include <fstream>
// #include <functional>
// #include <future>
// #include <initializer_list>
// #include <iomanip>
// #include <ios>
// #include <iosfwd>
// #include <iostream>
// #include <istream>
// #include <iterator>
// #include <latch>
// #include <limits>
// #include <list>
// #include <locale>
// #include <map>
// #include <memory>
// /* #include <memory_resource> */
// #include <mutex>
// #include <new>
// #include <numbers>
// #include <numeric>
// #include <optional>
// #include <ostream>
// #include <queue>
// #include <random>
// #include <ranges>
// #include <ratio>
// #include <regex>
// #include <scoped_allocator>
// #include <semaphore>
// #include <set>
// #include <shared_mutex>
// /* #include <source_location> */
// #include <span>
// /* #include <spanstream> */
// #include <sstream>
// #include <stack>
// /* #include <stacktrace> */
// #include <stdatomic.h>
// #include <stdexcept>
// /* #include <stop_token> */
// #include <streambuf>
// #include <string>
// #include <string_view>
// /* #include <syncstream> */
// #include <system_error>
// #include <thread>
// #include <tuple>
// #include <typeindex>
// #include <typeinfo>
// #include <type_traits>
// #include <unordered_map>
// #include <unordered_set>
// #include <utility>
// #include <valarray>
// #include <variant>
// #include <vector>
// #include <version>
//

#include <std.hpp>

namespace myPrint {

#define Forward(...) std::forward<decltype(__VA_ARGS__)>(__VA_ARGS__)

template<typename UnknownType, typename ReferenceType>
concept SubtypeOf = std::same_as<std::decay_t<UnknownType>, ReferenceType> || std::derived_from<std::decay_t<UnknownType>, ReferenceType>;

template<typename UnknownType, typename ...ReferenceTypes>
concept AnyOf = (SubtypeOf<UnknownType, ReferenceTypes> || ...);

template<typename UnknownType, typename ...ReferenceTypes>
concept AnyBut = !AnyOf<UnknownType, ReferenceTypes...>;

template<typename UnknownType, typename ReferenceType>
concept ExplicitlyConvertibleTo = requires(UnknownType x) { static_cast<ReferenceType>(Forward(x)); };

template<typename UnknownType>
concept BuiltinArray = std::is_array_v<std::remove_cvref_t<UnknownType>>;

template<typename UnknownType>
concept Advanceable = requires(UnknownType x) { ++x; };

template<typename UnknownType>
concept Iterable = BuiltinArray<UnknownType> || requires(UnknownType x) {
	{ x.begin() }->Advanceable;
	{ *x.begin() }->AnyBut<void>;
	{ x.begin() != x.end() }->ExplicitlyConvertibleTo<bool>;
};

template<typename UnknownType, auto Index>
concept ReachableAt = requires(UnknownType x) { { std::get<Index>(x) }->AnyBut<void>; };

template<typename UnknownType>
concept Expandable = []<auto ...x>(std::index_sequence<x...>) {
  return (ReachableAt<UnknownType, x> && ...);
}(std::make_index_sequence<std::tuple_size<std::remove_cvref_t<UnknownType>>{}>{});

template<typename UnknownType>
struct ExtractInnermostTypeArgument {
	using IrreducibleType = UnknownType;
};

template<Iterable UnknownType>
    requires (BuiltinArray<UnknownType> == false)
struct ExtractInnermostTypeArgument<UnknownType> {
	using InnerType = std::remove_cvref_t<decltype(*std::declval<UnknownType>().begin())>;
	using IrreducibleType = typename ExtractInnermostTypeArgument<InnerType>::IrreducibleType;
};

template<typename UnknownType, auto Length>
struct ExtractInnermostTypeArgument<UnknownType[Length]> {
	using InnerType = std::remove_cvref_t<UnknownType>;
	using IrreducibleType = typename ExtractInnermostTypeArgument<InnerType>::IrreducibleType;
};

template<typename UnknownType>
using ExtractInnermostElementType = typename ExtractInnermostTypeArgument<std::remove_cvref_t<UnknownType>>::IrreducibleType;

auto& operator<<(SubtypeOf<std::ostream> auto&,
                 const Expandable auto& Container)
    requires (requires { { Container }->Iterable; } == false);

auto& operator<<(SubtypeOf<std::ostream> auto& Printer,
                 const Iterable auto& Container)
    requires requires { Printer << std::declval<ExtractInnermostElementType<decltype(Container)>>(); } {
	auto [Startpoint, Endpoint] = [&]{
		if constexpr (requires { { Container }->BuiltinArray; }) {
			return std::tuple{ Container, Container + sizeof(Container) / sizeof(Container[0]) };
    } else {
			return std::tuple{ std::begin(Container), std::end(Container) };
    }
	}();
	Printer << "[";
	for (auto Cursor = Startpoint; Cursor != Endpoint; ++Cursor)
		if (Cursor != Startpoint)
			Printer << ", " << *Cursor;
		else
			Printer << *Cursor;
	Printer << "]";
	return Printer;
}

auto& operator<<(SubtypeOf<std::ostream> auto& Printer,
                 const Expandable auto& Container)
    requires (requires { { Container } -> Iterable; } == false) {
	Printer << "(";

	if constexpr (std::tuple_size_v<std::decay_t<decltype(Container)>> != 0) {
    auto applicand = [&](auto&& FirstElement, auto&& ...Elements) {
			Printer << FirstElement;
      auto f = [&](auto&& x){ Printer << ", " << x; };
			(f(Elements), ...);
		};
		std::apply(applicand, Container);
  }

	Printer << ")";
	return Printer;
}

} // namespace myPrint

namespace olib {

/* auto print(auto... args) { */
/*   using namespace myPrint; */
/*   (std::cout << ... << args) << std::endl; */
/* } */

////////////////////////////////////////////////////////////
// types and names
////////////////////////////////////////////////////////////

using u8  =  uint8_t;
using u32 = uint32_t;
using u64 = uint64_t;
using i8  =   int8_t;
using i32 =  int32_t;
using i64 =  int64_t;

using std::tuple;
using std::vector;
using std::string;
using std::map;
using std::pair;
using std::function;
using std::cin;
using std::cout;
using std::cerr;
using std::iostream;
using std::istream;
using std::ostream;
using std::fstream;
using std::ifstream;
using std::ofstream;
using std::stringstream;
using std::istringstream;
using std::ostringstream;
using std::bitset;
using std::endl;
using std::iota;
using std::reverse;
using std::min;
using std::max;
using std::initializer_list;
using std::set;
using std::stack;
using std::swap;
using std::atoi;
using std::to_string;
using std::tie;

auto all(const auto&... args) { return (... && args); }
auto any(const auto&... args) { return (... || args); }
auto combine(const auto&... args) { return (... | args); }
auto is_in(const auto& x, const auto&... args) { return (... || (x == args)); }

auto&& out(auto&& os, const auto&... args) {
  using namespace myPrint;
  (void)(os << ... << args);
  return os;
}
auto put(const auto&... args) { out(cout, args...); }
auto print(const auto&... args) { put(args..., '\n'); }
auto str(const auto&... args) { return out(stringstream(), args...).str(); }

/* auto&& out_delim(auto&& os, const auto&... args) { (os << ... << ' ' << args); return os; } */

auto repeat(auto n, auto f) { for (auto i = 0; i < n; i++) f(); }

auto&& each(auto&& c, auto f) {
  std::ranges::for_each(c, f);
  return c;
}

/* auto each(auto c, auto f) { */
/*   std::ranges::for_each(c, f); */
/* } */

auto _getline(istream& is) {
  string line;
  std::getline(is, line);
  return line;
}

auto _getline() {
  return _getline(cin);
}

/* template <typename T> */
/* auto _getline(T t) { */
/*   put(t); */
/*   return _getline(); */
/* } */

template <typename T=string>
auto get(istream& is=std::cin) {
  auto t = T();
  is >> t;
  return t;
}

template <typename T=string>
auto get_vec(istream& is=std::cin) {
  auto v = vector<T>();
  for (T t; is >> t;)
    v.push_back(t);
  return v;
}

template <typename T=string>
auto get_vec(auto n, istream& is=std::cin) {
  auto v = vector<T>();
  v.reserve(n);
  for (auto i = 0; i < n; i++)
    v.push_back(get<T>(is));
  return v;
}

template <typename T=string>
auto get_vec_n(auto n, istream& is=std::cin) {
  auto v = vector<T>();
  v.reserve(n);
  for (auto i = 0; i < n; i++)
    v.push_back(get<T>(is));
  return v;
}

auto input(const auto& s) {
  put(s);
  auto input = std::string();
  std::getline(std::cin, input);
  return input;
}

auto die(const auto&... args) {
  if (sizeof...(args)) {
    print(args...);
  }
  exit(EXIT_FAILURE);
}

// clear terminal screen
void clear() {
  auto s = "\x1b[2J";
  auto t = "\x1b[H";
  put(s, t);
}

auto find(const auto& c, const auto& x) {
  return std::ranges::find(c, x) != std::end(c);
}

auto contains(auto& container, auto& elem) {
  return find(container, elem);
}

auto uniq(auto v) {
  auto s = set(begin(v), end(v));
  return decltype(v)(begin(s), end(s));
}

auto range(auto lo, auto hi) {
  return std::views::iota(lo, hi);
}

auto range(auto hi) {
  return range(0, hi);
}

namespace math {

auto clamp(auto& x, auto min, auto max) {
  if (x < min) return x = min;
  if (x > max) return x = max;
  return x;
}

auto clamp01(auto& x){ return clamp(x,0,1); }

auto clamp_pm(auto& x, auto pm) { return clamp(x, -pm, pm); }

auto clamp_pm1(auto& x) { return clamp_pm(x, 1); }

auto clamp0(auto& x, auto max) { return clamp(x, 0, max); }

} // namespace math

template<typename T, typename TIter = decltype(std::begin(std::declval<T>()))>
constexpr auto enumerate(T&& iterable) {
  struct iterator {
    size_t i;
    TIter iter;
    bool operator!=(const iterator& other) const { return iter != other.iter; }
    void operator++() { ++i; ++iter; }
    auto operator*() const { return std::tie(i, *iter); }
  };
  struct iterable_wrapper {
    T iterable;
    auto begin() { return iterator{0, std::begin(iterable)}; }
    auto end() { return iterator{0, std::end(iterable)}; }
  };
  return iterable_wrapper{std::forward<T>(iterable)};
}

constexpr auto indices(auto&& iterable) {
  struct iterator {
    ssize_t i;
    auto operator!=(const iterator& other) const -> bool { return i != other.i; }
    auto operator++() -> void { ++i; }
    auto operator*() const -> decltype(i) { return i; }
  };
  struct iterable_wrapper {
    ssize_t n;
    auto begin() { return iterator{0}; }
    auto end() { return iterator{n}; }
  };
  return iterable_wrapper{std::ranges::ssize(iterable)};
}

} // namespace olib

using olib::print;
using olib::put;
using olib::range;

using i8 = int8_t;
using i8 = int8_t;
using i16 = int16_t;
using i16 = int16_t;
using i32 = int32_t;
using i32 = int32_t;
using i64 = int64_t;
using i64 = int64_t;
using u8 = uint8_t;
using u8 = uint8_t;
using u16 = uint16_t;
using u16 = uint16_t;
using u32 = uint32_t;
using u32 = uint32_t;
using u64 = uint64_t;
using u64 = uint64_t;

using isize = ssize_t;
using usize = size_t;

#endif // #ifndef ALL_HPP
