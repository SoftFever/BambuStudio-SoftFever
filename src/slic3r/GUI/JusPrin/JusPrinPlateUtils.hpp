#ifndef slic3r_GUI_JusPrinPlateUtils_hpp_
#define slic3r_GUI_JusPrinPlateUtils_hpp_

#include <nlohmann/json.hpp>
#include <GL/glew.h>

#include "libslic3r/GCode/ThumbnailData.hpp"
#include "slic3r/GUI/Camera.hpp"

namespace Slic3r { namespace GUI {

class JusPrinPlateUtils {
public:
    static nlohmann::json GetPlate2DImages(const nlohmann::json& params);
    static nlohmann::json GetPlates(const nlohmann::json& params);

private:
    static void RenderThumbnail(ThumbnailData& thumbnail_data,
        const Vec3d& camera_position, const Vec3d& target);
};

}} // namespace Slic3r::GUI

#endif
